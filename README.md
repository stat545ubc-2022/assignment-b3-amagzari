The file contains the four elements requested for assignment B3:  

<br>
- A link to a running instance of my Shiny app:  
https://amagzari.shinyapps.io/stockmarketdashboard/  

<br>
<br>
- My choice of assignment clearly stated:  
Option B - My own Shiny app.  

<br>
<br>
- A description of my app:  
<br>
This application queries the user to enter a stock symbol (AAPL, MSFT, ...) and 
a desired start date. 
<br>
In return, a table is rendered in the first tab of the main panel.  
The table contains daily price information (open, close, low, high, volume, adjusted) from the desired start date to today's date for the particular stock.  
<br>
The user has the ability to download the csv file containing the table by clicking on the *Download* button. In the second tab of the main panel, a standard financial chart is displayed for the desired stock and period starting from the desired start date to today's date.  

<br>
<br>
- Whatever dataset you will use, acknowledge its source clearly:   
The application uses the *quantmod* library that relies on *yahoo* to retrieve the data.
