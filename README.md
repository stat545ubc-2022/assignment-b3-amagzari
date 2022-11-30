---
output:
  pdf_document: default
  html_document: default
---
# README

The **app.R** file contains the code used to improve the Shiny app completed in assignment B-3. The improved application is fully-functioning and deployed. Its URL is shown below:  

https://amagzari.shinyapps.io/StockMarketBoard/?_ga=2.59447022.231963512.1669697863-1263216897.1669464076  

## Description and instructions

This application is a simple stock market dashboard.  On the sidebar panel, the user is prompted to enter the following information: 
<br>
* Stock symbol (default value is MSFT)  
* Start date (default value is 2020-01-10)  
* End date (default value is the current's date)  
<br>
At the bottom of the sidebar panel, there is a link that, upon clicking, lead the user to a list of accepted stock symbols.  

<br>
After filling the necessary information, a table is generated on the main panel under the **Table** tab. The table contains daily price information (open, close, low, high, volume, adjusted) for the desired stock and respective period.  

<br>
Above the table resides a **Download** button that generates csv file upon clicking in which the table is stored.  

<br>
In the second tab of the main panel, a standard financial chart is displayed for the desired stock and respective period.   

<br>
In the third tab, The minimum and maximum daily volume of said stock and period are reported. Adding to that, the used is prompted to enter the volume range of interest. Once the information is entered and the **APPLY** button is clicked, a filtered table is rendered whose **Volume** column is within the desired range.  

## Improvements from B3 to B4:

* **Shinythemes**
* **End date** textInput
* Default values setting for the stock symbol, start and end date fields
* Clickable link that leads to file containing list of accepted tickers
* Moving the **Download** button from sidebar to main pannel, in the first tab
* Third tab:
  * Reporting of minimimum and maximum volume
  * textInput for desired volume range
  * **FILTER** button to render filtered table
