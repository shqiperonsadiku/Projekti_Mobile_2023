# To Do List App
Ky është një aplikacion që mundëson organizimin e ditës tënde, bazuar në detyrat të cilat i ke si objektiv për ti kryer.

## Përshkrimi
To Do List App është një aplikacion i thjeshtë, si nismë e programimit të aplikacioneve mobile në platformën IOS. Edhepse i thjeshtë si aplikacion është mjaft praktik dhe i nevojshëm për përdorim të përditshëm dhe lehtësim të një pjese mjaft të rëndësishme të ditës, siç është planifikimi dhe vendosja e qëllimeve të vogla që duhet plotësuar për çdo ditë, që të arrijmë qëllime më të mëdha. 

## Fillimi i punës për zhvillimin e aplikacionit
- Së pari duhet të sigurojmë platformën 'macOS' për t'u mundësuar zhvillimi i kodit për çdo aplikacion në IOS. Këtë mund ta arrijme përmes VirtualBox nëse jemi duke punuar me një pajisje Windows apo përmes një pajisje me sistemin operativ MAC, në rastin më të mirë.
- Pastaj nevojitet mjedisi ku do të zhvillohet dhe ekzekutohet aplikacioni (IDE). Këtë e arrijmë përmes XCode IDE që mundëson ekzekutimin e aplikacioneve të krijuara për IOS.
- Për zhvillimin e këtij aplikacioni përkatës është përdorur versioni XCODE 12.5.1, me IOS versisionin max. 14.5

## Struktura e projektit  
- Projekti është i zhvilluar në gjuhën programuese 'Swift' që suportohet nga pajisjet IOS,
- Interface i përdorur për krijimin e layouts është Storyboard,
- LifeCycle: UIKit App Delegate
- Për krijimin e databazës së brendshme kam perdorur opsionin CoreData.

## Logjika e funksionimit të aplikacionit
- Aplikacioni përmban dy Controllera për trajtimin e 'View'-ave të cilat funksionalizohen përmes metodave dhe funksioneve të ndryshme brenda klasës së Controller-ave.
- Controlleri i parë 'HomeViewController' trajton 'Welcome Page' të aplikacionit, e cila shfaq një mesazh dhe na mundëson që përmes një butoni të navigojme te main page.
- Controlleri i dytë 'ViewController' përmban klasën përkatëse që mundëson krijimin e logjikës kryesore të aplikacionit përmes funksioneve të saj.
- Në 'View Controller' përfshihen funksionet për krijimin, editimin, dhe fshirjen e taskave të ditës që përfshihen në To Do List.
- Të dhënat që krijohen paraqiten si rreshta të një TableView.
- Ekziston mundësia e filtrimit të rreshtave përmes butonave 'Previous Tasks' dhe 'Today Tasks' që filtrojne rreshtat në baze të datës.
- Rreshtat qe krijohen ruhen në databazën e brendshme në entititetin 'ToDoListItem' që përmban atributet 'name' dhe 'createdAt'.
- Name: ruan të dhënat e krijuara si String në databazë.
- CreatedAt: ruan datën kur janë krijuar ato të dhëna
- Rreshtat e tableView paraqiten me dizajn.
- Me ngjyrë të gjelbër janë rreshtat që paraqesin të dhënat për filtrin 'Today', ndërsa me ngjyre hiri paraqiten të dhënat për filtrin 'Previous Tasks'.
