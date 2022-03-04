import sqlite3

def make_check_keywords(filename):
    with open(filename) as fp:
        terms = [term.lower() for term in fp.read().split("\n") if term]

    print(terms)

    def check_keywords(text):
        text = text.lower()
        return any(term in text for term in terms)

    return check_keywords

con = sqlite3.connect("crs_candid_cgap.db")
con.create_function("check_keywords_gender", 1, make_check_keywords("terms_gender.txt"))
cursor = con.cursor()
with open("combine_keywords.sql") as fp:
    cursor.executescript(fp.read())
