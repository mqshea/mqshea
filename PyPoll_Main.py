#import modules
import os
import csv

#set up file path
PyPollCsv = os.path.join("Resources","election_data.csv")

#output file for survey analysis
outputFile = os.path.join("PyPollData.txt")

#print(PyPollCsv)

#variables
totalVotes = 0 #variable that holds the total number of votes
candidates = [] #lists that holds the flavors inn the survey
candidateVotes = {} #dictionary that will hold the votes for each candidate
winningCount = 0 # variable that will hold the winning count
winningCandidate = "" #variable to hold the winning candidate

#read the csv file
with open(PyPollCsv) as surveryData:
    #create the csv reader
    csvreader = csv.reader(surveryData)

    # read in the header
    header = next(csvreader)

    # rows will be lists
        #index 0 is the user id
        #index 1 is the user's choice of candidate

    # for each row
    for row in csvreader:
        #add on to the total votes
        totalVotes += 1 #same as totalVotes = totalVotes + 1

        #check to see if candidate is in list of candidates
        if row[1] not in candidates:
            #if the candidate is not in the list, add the candidate in
            candidates.append(row[1])

            # add the value to the dictionary as well
            # { "key": value }
            # start the count at one for the votes
            candidateVotes[row[1]] = 1

        else:
            # the candidate is in the list
            # add a vote to the respective candidate
            candidateVotes[row[1]] += 1

#print(candidateVotes)
voteOutput = ""

for candidates in candidateVotes:
    #get the vote count and the percentage of the votes
    votes = candidateVotes.get(candidates)
    votePct = (float(votes) / float(totalVotes)) * 100
    voteOutput += f"{candidates}: {votePct:.2f}% \n"
    
    #compare our votes to the winning count
    if votes > winningCount:
        #update the votes to be the new winning count
        winningCount = votes
        #update winning candidate
        winningCandidate = candidates

winningCandidateOutput = f"Winner: {winningCandidate}\n-----------------------"
#create an output variable to hold the output
output = (
    f"\n\nSurvey Results\n"
    f"-----------------------\n"
    f"\tTotal Votes: {totalVotes:,} \n"
    f"-----------------------\n"
    f"{voteOutput} \n"
    f"-----------------------\n"
    f"{winningCandidateOutput}"
)

print(output)

#print the results and export the data to a text file
with open(outputFile, "w") as textFile:
    #write the pieces of output for text file
    textFile.write(output)