---Cleaning Data in SQL------------------------------------------------------------------------------------------------------------
Select * From NashvilleHousing

---- Standardise Data Formats---
Select SaleDate, CONVERT(Date,SaleDate) From NashvilleHousing

Update NashvilleHousing Set SaleDate = Convert( Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

Select SaleDateConverted From NashvilleHousing

-----Populate Property Address Date-----

Select * From NashvilleHousing
---Where PropertyAddress is Null
order by ParcelID


----We need to Join itself---
Select a.ParcelID ,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NUll

---1) Step 1:Select All and Order By Parcel ID
---Note: Same ID with same address
---If this parcelid have the address and the other parcel ID do not have address lets populate with the address.
---2) Step 2: We need to do self join
---3) We need to add AND criteria of uniqueID being different 
---4) Select parcel id and property address
---And keep one table i.e a.ParcelID has not Null
---5) ISNULL - what do we want to check is it is not null
---we need to check a.propertyadress and if it is null then we need to populate b.propertyaddress

Update a
Set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NUll

---When we need to update we need to use  alias statement


----Breaking out address into Individual colunms (Address,City,State)---------------------------------------------------------------

Select PropertyAddress
From NashvilleHousing
--- Where PropertyAddress is null
----Order By ParcelID

---We need to use delimiter to seperate different  column for this set we use  ','-----

Select 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
---CHARINDEX(',',PropertyAddress)
,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
----- We want to start where the ',' is i.e CHARINDEX(',',PropertyAddress) +1)
From NashvilleHousing
-----After , The remaing data after PropertyAdress is selected i.e ex:GOODLETTSVILLE



----It is going to the propertyaddress at the first value and the it is going to the comma we dont need to comma 
----If we look at only charidex it will give us number @ position 19 i.e where the ',' is.
------If we put -1, then we go to the comma and get rid of that ','.
----CharIndex looks for a specific value


Alter Table NashvilleHousing
Add PropertySpiltAddress NVarchar(255);

Update NashvilleHousing
Set PropertySpiltAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySpiltCity NVarchar(255);

Update NashvilleHousing
Set PropertySpiltCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select * From NashvilleHousing

------Instead of using Substring we use Patsename--------------------------------------------------------------

Select
ParseName(REPLACE(OwnerAddress,',','.'),3) 
, ParseName(REPLACE(OwnerAddress,',','.'),2)
, ParseName(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing

----Parsename does not work for ',' but for '.' so we replace comma to period.
----Lot easier than substring.

Alter Table NashvilleHousing
Add OwnersplitAddress NVarchar(255);

Update NashvilleHousing
Set OwnersplitAddress = ParseName(REPLACE(OwnerAddress,',','.'),3) 

Alter Table NashvilleHousing
Add OwnersplitCity NVarchar(255);

Update NashvilleHousing
Set OwnersplitCity = ParseName(REPLACE(OwnerAddress,',','.'),2) 

Alter Table NashvilleHousing
Add Ownersplitstate NVarchar(255);

Update NashvilleHousing
Set Ownersplitstate = ParseName(REPLACE(OwnerAddress,',','.'),1) 

Select * from NashvilleHousing


-----  Change Y and N to Yes and No in "Sold as vacant" feild.---------------------------------------------------------------------

Select Distinct (SoldAsVacant),COunt (SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End


------Remove Duplicates ------------------------------------------------------------------------------------------------------------

WITH CTE_ROWNUM As(Select *, 
        ROW_NUMBER() 
Over (Partition By ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order By UniqueId )
row_num From NashvilleHousing)
---Delete 
--From CTE_ROWNUM
---Where row_num >1
Select *
From CTE_ROWNUM
Where row_num >1
Order by PropertyAddress

----We may have duplicate rows to find them we use Rank ,Order Rank, Row number .
----We are using the row number because it is the simplest.

--Delete Unseen Colunms-------------------------------------------------------------------------------------------------------------

Alter Table NashvilleHousing
Drop Column SaleDate

Alter Table NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

---------------------------END------------------------------------------------------------------------------------------------------



         






