import itertools
import sqlite3
import sys
import unicodedata

# These appear in the middle of words
punctuation_to_keep = ["-", "–", "'", "’", "_"]

# https://stackoverflow.com/questions/11066400/remove-punctuation-from-unicode-formatted-strings
tbl = {i:" " for i in range(sys.maxunicode) if unicodedata.category(chr(i)).startswith('P')}
for punctuation in punctuation_to_keep:
    del tbl[ord(punctuation)]
print({chr(k): v for k,v in tbl.items()})
def remove_punctuation(text):
    return text.translate(tbl)

def make_check_keywords(filename):
    with open(filename) as fp:
        terms = fp.read().split("\n")
        terms = [
            unicodedata.normalize("NFKC", term.lower())
            for term in terms
            if term
        ]
        for term in terms:
            try:
                assert term == remove_punctuation(term)
            except AssertionError:
                print(term)
                raise

    print(terms)

    def check_keywords(text):
        text = unicodedata.normalize("NFKC", text.lower())
        for punctuation in punctuation_to_keep:
            # punctuation we want to keep followed by a space is not in the middle of a word, so remove
            text = text.replace(punctuation+" ", " ")
        text = remove_punctuation(text) 
        return any(term in text for term in terms)

    return check_keywords

con = sqlite3.connect("crs_candid_cgap.db")
for term_category in ["gender", "covid", "wfi", "wec", "groups_of_women"]:
    con.create_function(f"check_keywords_{term_category}", 1, make_check_keywords(f"terms/{term_category}.txt"))
cursor = con.cursor()
with open("combine_keywords.sql") as fp:
    cursor.executescript(fp.read())
