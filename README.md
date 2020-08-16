# Mail-In Ballot Dropoff Identifier
Given the recent slow down in USPS services, voters the turn in their ballots within 3 weeks in the 2020 election risk having their votes not counted. Based on a Google search in the State of Pennsylvania, it took me 2-3 minutes to figure out where to physically turn in a ballot if I were a PA voter. I was also very specific in what I was looking for, something I cannot assume an average voter will be.

This repo will serve as a collection point for data obtained on drop off locations. Another layer will be giving information on `proxy` drop-off voting. That information has been collected by the [NCSL](https://www.ncsl.org/research/elections-and-campaigns/vopp-table-10-who-can-collect-and-return-an-absentee-ballot-other-than-the-voter.aspx#table), so that will be a layer added.

## Data requirements
1. Each state should have a CSV with the following schema:

|state |state abbreviation|locality              |locality type |address              | Phone
|:-----|:-----|:---------------------|:-----|:---------------------|:---------------------|


I decided against email because phone numbers require urgency, emails can be ignored.
The CSVs with this data should be stored under `Data/drop-off-locations` as csvs named using the the abbreviation.

2. Documented source of data
  The documentation is important because if there is an issue, the documentation should be used to justify the approach

## UI
Shiny Dashboard to start with to show the the data and make a quick POC. I may have to rely on TFC to productionalize it.
POC is up for Pennsylvania. The site has three dropdowns, state, zipcode or county. Only one state, **Pennsylvania**, but selecting a county or zip gets you to the address of an election office and a google maps link along with a telephone number.
In addition, I have a fact table to let people know at the state level whether they can drop off someone else's ballot and requirements from the by the [NCSL website](https://www.ncsl.org/research/elections-and-campaigns/vopp-table-10-who-can-collect-and-return-an-absentee-ballot-other-than-the-voter.aspx#table).

## Things I will need help with
1. Collecting the Data. It took me about two hours to scrap and clean PA election data, there are 49 other states plus DC that have this data. Based on discussions on Twitter and TFC Slack I've found other state sites with this info but will need help collecting and processing location information.

2. I love shiny and csvs (well maybe not csvs), but this needs to go into a Database. I'm a Data Scientist, so the best I can do is query data and maybe create snapshot files for an ETL process, but building a DB is beyond my skills. The webapp is cool, but shiny have limitations. 

3. Spread the word. GOTV channels, send to campaigns, literally anything to tell people to go here if they need help.


## Usage by others
The data I gathered is public, if you want to use it, I have no issues, but I will require that you site this Github repo in the name of reproduciblity
