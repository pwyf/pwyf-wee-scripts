import itertools
import sqlite3
import sys
import unicodedata

# https://stackoverflow.com/questions/11066400/remove-punctuation-from-unicode-formatted-strings
tbl = dict.fromkeys(i for i in range(sys.maxunicode)
                      if unicodedata.category(chr(i)).startswith('P'))
# These appear in the middle of words
del tbl[ord("-")]
del tbl[ord("'")]
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
            assert term == remove_punctuation(term)

    print(terms)

    def check_keywords(text):
        text = remove_punctuation(unicodedata.normalize("NFKC", text.lower()).replace("- ", " ").replace("' ", " "))
        return any(term in text for term in terms)

    return check_keywords

con = sqlite3.connect("crs_candid_cgap.db")
con.create_function("check_keywords_gender", 1, make_check_keywords("terms_gender.txt"))
cursor = con.cursor()
with open("combine_keywords.sql") as fp:
    cursor.executescript(fp.read())
