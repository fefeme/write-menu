function Write-Menu() {
    [CmdletBinding()]
    param (
        [parameter(valueFromPipeline=$true)][object[]]$Items,
        [parameter()][string]$Property,
        [parameter()][int32]$PageSize,
        [parameter()][string]$Title
        
    )    
    begin {
        function Get-Page($MenuItems, $PageSize, $CurrentPage) {
            $Start = [math]::Min(($CurrentPage - 1) * $PageSize, $MenuItems.Length )
            $End = [math]::Min(($CurrentPage  * $PageSize) - 1, $MenuItems.Length - 1)


            return New-Object PSObject @{
                Items = $MenuItems[$Start..$End]
                Page = $CurrentPage
                PageSize = $PageSize
                Start = $Start
                End = $End
                NumPages = [math]::Ceiling($MenuItems.Length / $PageSize)
            }
        }

        function Repaint($MenuItems, $Page, $Selected) {
            Clear-host

            $Pos = $Top

            foreach ($MenuItem in $Page.Items){
                [System.Console]::SetCursorPosition(2, $Pos) 
                [System.Console]::ForegroundColor = $ColorFG
                [System.Console]::BackgroundColor = $ColorBG

                if ($MenuItem -eq $Selected) {
                    [System.Console]::ForegroundColor = $ColorFGSelected
                    [System.Console]::BackgroundColor = $ColorBGSelected
                }

                if ($Property) {
                    [System.Console]::Write($MenuItem."$Property")
                }
                else {
                    [System.Console]::Write($MenuItem)
                }

                $Pos++
            }
            
            # Print Pager
            if ($Page.NumPages -gt 1) {
                [System.Console]::ForegroundColor = $ColorFG
                [System.Console]::BackgroundColor = $ColorBG

                [System.Console]::SetCursorPosition(2, $Pos + 2)
                [System.Console]::Write("Page $($Page.Page) / $($Page.NumPages)")
            }
        }

        $ColorFG = [System.Console]::ForegroundColor
        $ColorBG = [System.Console]::BackgroundColor

        $ColorFGSelected = $ColorBG
        $ColorBGSelected = $colorFG

        $MenuItems = @()

        $Offset = 5
        $Top = 1

        if ($Title -notlike $null) {
            $Host.UI.RawUI.WindowTitle = $Title
            $Top = 3
            $Offset = 7
        }

        if ($PageSize -eq 0){
            $PageSize = $Host.UI.RawUI.WindowSize.Height - $Offset
        }
        
    }

    process{
        $MenuItems += $Items
    }

    end{
        [System.Console]::CursorVisible = $false
        
        $CurrentPage = 1
        $Index = 0
        $Page = Get-Page $MenuItems $PageSize $CurrentPage
            
    
        :MenuLoop do {
            Repaint $MenuItems $Page $MenuItems.Get($Index)
            $Input = [System.Console]::ReadKey($true)

            switch ($Input.Key) {
                {$_ -in 'Escape','Backspace'} {
                    [System.Console]::WriteLine("`r`n")
                    break MenuLoop;
                }
                'DownArrow' {
                    if ($Index + 1 -le $Page.End) {
                        $Index++
                    }
                    else {
                        $Index = $Page.Start
                    }

                }
                'UpArrow' {
                    if ($Index - 1  -ge $Page.Start) {
                        $Index--
                    }
                    else {
                        $Index = $Page.End
                    }
                }
                'RightArrow'  {
                    if ($CurrentPage + 1 -le $Page.NumPages) {
                        $CurrentPage++
                        $Page = Get-Page $MenuItems $PageSize $CurrentPage
                        $Index = $Page.Start
                    }
                }
                'LeftArrow' {
                    if ($CurrentPage - 1 -gt 0) {
                        $CurrentPage--
                        $Page = Get-Page $MenuItems $PageSize $CurrentPage
                        $Index = $Page.End
                    }
                }
                'Enter' {
                    return $MenuItems.Get($Index)
                }
            }



        } While ($true)

        [System.Console]::ForegroundColor = $ColorFG
        [System.Console]::BackgroundColor = $ColorBG
        [System.Console]::CursorVisible = $true

    }
}

