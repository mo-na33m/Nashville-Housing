


SELECT * FROM [Nashville Housing ]..NashvilleHousing

--Changing Date format 

SELECT SaleDate, (cast(SaleDate AS DATE ))
FROM [Nashville Housing ]..NashvilleHousing
or
SELECT SaleDate, CONVERT(DATE,SaleDate)
FROM [Nashville Housing ]..NashvilleHousing


UPDATE [Nashville Housing ].. NashvilleHousing
SET SaleDate2 = CONVERT(DATE,SaleDate)

ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD SaleDate2 DATE

--Populate  address data 

SELECT PropertyAddress
FROM [Nashville Housing ]..NashvilleHousing
WHERE PropertyAddress IS NULL 


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville Housing ]..NashvilleHousing AS a
JOIN [Nashville Housing ]..NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 


UPDATE a
SET  PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville Housing ]..NashvilleHousing AS a
JOIN [Nashville Housing ]..NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 


-- Breaking address into differnt columns 


SELECT PropertyAddress
FROM [Nashville Housing ]..NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address

FROM [Nashville Housing ]..NashvilleHousing



ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD PropertyAddressSplit NVARCHAR (255)

UPDATE [Nashville Housing ].. NashvilleHousing
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD PropertySplitCity NVARCHAR (255)

UPDATE [Nashville Housing ].. NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
FROM [Nashville Housing ]..NashvilleHousing


SELECT OwnerAddress
FROM [Nashville Housing ]..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM [Nashville Housing ]..NashvilleHousing


ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD OwnerAddressSplit NVARCHAR (255)

UPDATE [Nashville Housing ].. NashvilleHousing
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD OwnerSplitCity NVARCHAR (255)

UPDATE [Nashville Housing ].. NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE [Nashville Housing ].. NashvilleHousing
ADD OwnerAddressState NVARCHAR (255)

UPDATE [Nashville Housing ].. NashvilleHousing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


--Changing Y to Yes and N to 'No for the SoldAsvacant Column.  

SELECT DISTINCT(SoldAsvacant), COUNT(SoldAsvacant) AS a
FROM [Nashville Housing ]..NashvilleHousing
GROUP BY SoldAsvacant
ORDER BY a



SELECT SoldAsvacant,
CASE WHEN SoldAsvacant = 'Y' THEN 'Yes'
WHEN SoldAsvacant = 'N' THEN 'No'
ELSE SoldAsvacant
END
FROM [Nashville Housing ]..NashvilleHousing


UPDATE [Nashville Housing ]..NashvilleHousing
SET SoldAsvacant = CASE WHEN SoldAsvacant = 'Y' THEN 'Yes'
WHEN SoldAsvacant = 'N' THEN 'No'
ELSE SoldAsvacant
END




--Removing Duplicates 


WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) row_num

FROM [Nashville Housing ]..NashvilleHousing)
SELECT *         --- Then Change to Delete without the Order by to delete all rows of duplicate details  
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--DELETE Unused Columns 

ALTER TABLE [Nashville Housing ]..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE [Nashville Housing ]..NashvilleHousing
DROP COLUMN SaleDate



SELECT *
FROM [Nashville Housing ]..NashvilleHousing

 







