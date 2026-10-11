/*
Cleaing Data in SQL Queries
*/

SELECT * FROM PortfolioProject.dbo.NashvilleHousing
USE PortfolioProject;
GO
------Standardize Date Format--------------

SELECT SaleDateConverted, CONVERT(Date,SaleDate) as Sale_Date 
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---Populate Property Address data-------

SELECT * 
FROM NashvilleHousing
WHERE PropertyAddress is null;

SELECT * 
FROM NashvilleHousing
order by ParcelID;

SELECT * 
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL ( a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null;

UPDATE a
SET PropertyAddress = ISNULL ( a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null;


------ Breaking out Address into Individual Columns (Address, City, State)--------

Select PropertyAddress
From NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1) as Address
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM NashvilleHousing

SELECT OwnerAddress FROM NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT * FROM NashvilleHousing

---Change Y and N to Yes and No in 'Sold as Vacant' field----

Select  DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
From NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant) DESC;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

----Remove Duplicates------

WITH RowNumCTE AS (
SELECT*,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

/*
--------------------------------------------------------------------------------
NOTE DE PRODUCTION / BONNE PRATIQUE :
Dans un environnement de production réel, la suppression directe de colonnes 
(ALTER TABLE ... DROP COLUMN) sur une table brute est déconseillée afin de 
préserver l'intégrité de la source. 
Ici, cette étape est réalisée à des fins de démonstration dans une table de staging.
En pratique d'entreprise, on préférera :
  1. Conserver la table brute intacte.
  2. Créer une VUE (VIEW) n'exposant que les colonnes utiles et nettoyées.
--------------------------------------------------------------------------------
*/
---- Delete Unused Columns-------
SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate