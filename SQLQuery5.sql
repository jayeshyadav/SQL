/*
Cleaning Data in SQL Queries
*/

select *
from ProtfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------

--Standardize Date Format

select SaleDate
from ProtfolioProject.dbo.NashvilleHousing

select SaleDate,CONVERT(Date,SaleDate)
from ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Select SaledateConverted, CONVERT(Date,SaleDate)
from ProtfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------
--Populate Property Address data

Select *
From ProtfolioProject.dbo.NashvilleHousing
order by ParcelID

Select *
From ProtfolioProject.dbo.NashvilleHousing

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From ProtfolioProject.dbo.NashvilleHousing a
join ProtfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a  
Set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
From ProtfolioProject.dbo.NashvilleHousing a
join ProtfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address,City,State)

select PropertyAddress
from ProtfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertysplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add Propertysplitcity Nvarchar(255);

Update NashvilleHousing
SET Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From ProtfolioProject.dbo.NashvilleHousing

select OwnerAddress
from ProtfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnersplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add Ownersplitcity Nvarchar(255);

Update NashvilleHousing
SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add Ownersplitstate Nvarchar(255);

Update NashvilleHousing
SET Ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From ProtfolioProject.dbo.NashvilleHousing

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from ProtfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end
from ProtfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end 

---------------------------------------------------------------------------------------

--Remove Duplicates

select *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	            PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num

from ProtfolioProject.dbo.NashvilleHousing
order by ParcelID

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From ProtfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From ProtfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------

Select *
From ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE ProtfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

