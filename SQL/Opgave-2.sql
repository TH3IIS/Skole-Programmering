-- Opgave A
Select Wine,Producer,Bin from wine where bin = 72
-- Opgave B
Select Wine, Producer, Year From dbo.Wine where Year > '2013' -- Ud fra opgave 2 Står det ved importering at Year er NVARCHAR(50) og skal derfor søges som string
-- Opgave C
Select wine,bin,year,producer from wine where producer = 'Concha y Toro'
-- Opgave D
Select BIN, Label, Bottles from wine where bottles > 5 order by bottles DESC
-- Opgave E
Select BIN, Wine, Label, Producer, Type, Bottles from wine where wine = 'Pinot Noir'
-- Opgave F
Select Bin, type from wine where type = 'red'
-- Opgave G
Update wine set bottles = 10 where bin = 25
-- Opgave H
Update Wine set Bottles = Bottles + 6 where label = 'Ocean Spirit Chardonnay'
-- Opgave I
Update wine set Bottles = Bottles - 1 where label = 'Alsace Grand Cru Ollwiller Riesling' -- Jeg vælger at lade beholdningen går i nul da det vil give mere mening istedet for at slette hele varen
-- Opgave J
insert into wine (Bin,wine,label,producer,type,year,Price,bottles,comments)
	values (12,'Merlot','Anakena Merlot','Viña Anakena','Red', 2011, '69.95', 4, null)
-- Opgave k
Select sum(bottles) as 'Total antal af flasker', type from wine group by type
--Opgave I
Select sum(bottles * price) as 'Total værdi af kælder' from wine 