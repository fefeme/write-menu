# write-menu
Powershell CHUI Menu

## Why?

I tried a couple of other chui menu solutions for the powershell- but none of them really worked with the pipeline.
So i created ANOTHER one. *Sigh*. This one fits my needs- but it's not yet fully tested. 


## Usage

A simple example:

```powershell
 Get-NetAdapter | Write-Menu -Property Name | Get-NetIPAddress
````

![Demo](https://github.com/fefeme/write-menu/blob/develop/demo.gif)

Another example, with a list of strings this time. In case you're wondering: these are all beers from the menu of my favorite
berlin pub, hopfenreich:

```powershell
"Kuehnkrank Rosen Hell", "Schoppe Black Flag Imperial Stout",` 
"Brewberry Berliner Nacht", "Omnipollo Nebukadnezzar" | Write-Menu 
```

## Pagination

If the number of entries doesn't fit on the screen, you can scroll through the pages using left and right arrow.







