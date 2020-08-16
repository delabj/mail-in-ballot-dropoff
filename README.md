# Mail-In Ballot Dropoff Identifier
Given the recent slow down in USPS services, voters the turn in their ballots within 3 weeks in the 2020 election risk having their votes not counted. Based on a Google search in the State of Pennsylvania, it took me 2-3 minutes to figure out where to physically turn in a ballot if I were a PA voter. I was also very specific in what I was looking for, something I cannot assume an average voter will be.

This repo will serve as a collection point for data obtained on drop off locations. Another layer will be giving information on `proxy` drop-off voting. That information has been collected by the [NCSL](https://www.ncsl.org/research/elections-and-campaigns/vopp-table-10-who-can-collect-and-return-an-absentee-ballot-other-than-the-voter.aspx#table), so that will be a layer added.

## Data requirements
1. Each state should have a CSV with the following schema:

|state |state abbreviation|locality              |locality type |address              |
|:-----|:-----|:---------------------|:-----|:---------------------|

2. Documented source of data
  The documentation is important because if there is an issue, the documentation should be used to justify the approach

## UI
Shiny Dashboard to start with to show the the data and make a quick POC. I may have to rely on TFC to productionalize it.

## Usage by others
The data I gathered is public, if you want to use it, I have no issues, but I will require that you site this Github repo in the name of reproduciblity
