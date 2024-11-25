#import modules
import csv
import os

#set up fle path
PyBankCsv = os.path.join("Resources", "budget_data.csv")

#creating a file to hold total months
outputFile = os.path.join("revenueAnalysis.txt")

# print(PyBankCsv)

#Create variables
totalMonths = 0
profitLoss = 0
monthlyChanges = []
months = [] #initialize the ist of months

with open(PyBankCsv) as budgetData:

    #create the reader object
    csvreader = csv.reader(budgetData)

    header = next(csvreader)
    #move to next row for first revenue
    firstRow = next(csvreader)

    #count of total months
    totalMonths += 1 

    profitLoss += float(firstRow[1])

    # establish value of previous revenue as the first revenue as the first revenue we see
    previousRevenue = float(firstRow[1])

    for row in csvreader:

        #increment the count of total months
        #count of total months
        totalMonths += 1 

        profitLoss += float(row[1])

        #calculate the net change
        netChange = float(row[1]) - previousRevenue
        # add on to the list of monthly changes
        #adding on netChange
        monthlyChanges.append(netChange)

        # add the first month that a change occurred
            # month is in index 0
        months.append(row[0])

        #update previous revenue
        previousRevenue = float(row[1])

#calculate avg. net change per month
# the total divided by how many (len)
averageChangePerMonth = sum(monthlyChanges) / len(monthlyChanges)

greatestIncrease = [months[0], monthlyChanges[0]] # holds the month and value of greatest increase
greatestDecrease = [months[0], monthlyChanges[0]] # = greatest decrease

# use loop to calculate the index of the greatest and least monthly change
for m in range(len(monthlyChanges)):
    # calculate greatest in/decrease
    if(monthlyChanges[m] > greatestIncrease[1]):
        # if the value is greater than the greatest increase, that value will become new greatest increase
        greatestIncrease[1] = monthlyChanges[m]
        #update the month
        greatestIncrease[0] = months[m]

    if(monthlyChanges[m] < greatestDecrease[1]):
        # if the value is greater than the greatest decrease, that value will become new greatest decrease
        greatestDecrease[1] = monthlyChanges[m]
        #update the month
        greatestDecrease[0] = months[m]


#start generating output
output = (
    f"Revenue Data Analysis \n"
    f"--------------------------\n"
    f"\tTotal Months = {totalMonths} \n"
    f"\tTotal Revenue = ${profitLoss:,.2f} \n"
    f"\tAverage Change Per Month = ${averageChangePerMonth:,.2f} \n"
    f"\tGreatest Increase = {greatestIncrease[0]} Amount ${greatestIncrease[1]:,.2f} \n"
    f"\tGreatest Decrease = {greatestDecrease[0]} Amount ${greatestDecrease[1]:,.2f} \n"
    )
print(output)

#export total months to output txt file
with open(outputFile, "w") as textFile:
    textFile.write(output)



    