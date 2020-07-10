from pymongo import MongoClient
from pymongo.errors import DuplicateKeyError
import sys, os

username = os.environ['MONGO_USER']
password = os.environ['MONGO_PASSWORD']

def main(argv):
    # Init database connexion
    cnx = MongoClient('172.20.0.3',username=username,password=password)

    # Create HRE database and dcmdump collection
    db = cnx["HRE"]
    collection = db["dcmdump"]

    # Args <file> <StudyInstanceUID> <SeriesInstanceUID> <SOPInstanceUID
    print('Import ' + argv[1])
    document = {"_id": argv[1], "StudyInstanceUID": argv[2], "SeriesInstanceUID": argv[3], "SOPInstanceUID": argv[4]}

    try:
        result = collection.insert_one(document)
        if result.inserted_id:
            print('Success')

    except DuplicateKeyError:
        print("Failed - Import already exist")

if __name__ == "__main__":
   main(sys.argv)
