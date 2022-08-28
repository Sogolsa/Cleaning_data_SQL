/*
Cleaning Data in SQL Queries
*/


SELECT *
FROM project.dbo.hotel_bookings
ORDER BY arrival_date_year

--Changing The Date Format

SELECT reservation_status_date, CONVERT(Date, reservation_status_date, 103) AS con_ReservationStatusDate
FROM Project.dbo.hotel_bookings

UPDATE hotel_bookings
SET reservation_status_date = CONVERT(Date, reservation_status_date, 103) 

ALTER TABLE hotel_bookings
ADD con_reservation_status_date DATE;

UPDATE hotel_bookings
SET con_reservation_status_date = CONVERT(Date, reservation_status_date, 103) 

-- Concatinating The Arrival Date to One Column

SELECT CONCAT(arrival_date_year,'-', arrival_date_month, '-', arrival_date_day_of_month) AS ArrivalDate
FROM Project.dbo.hotel_bookings

ALTER TABLE hotel_bookings
ADD ArrivalDate Date;

UPDATE hotel_bookings
SET ArrivalDate = CONCAT(arrival_date_year,'-', arrival_date_month, '-', arrival_date_day_of_month)

SELECT*
FROM project.dbo.hotel_bookings



--Changing The Format of The Adults, Children and Babies Columns to Numeric 
--Adults

SELECT CAST(adults AS numeric) AS convertedAdults
FROM project.dbo.hotel_bookings

UPDATE project.dbo.hotel_bookings
SET adults = CAST(adults AS numeric)

ALTER TABLE Project.dbo.hotel_bookings
ADD ConvertedAdults NUMERIC;

UPDATE project.dbo.hotel_bookings
SET ConvertedAdults = CAST(adults AS NUMERIC)

--Have 4 NA Values in Childrens Children's Column
--Children

SELECT children
FROM project.dbo.hotel_bookings
WHERE children = 'NA'

SELECT cast(replace(children, 'NA','0') AS float ) AS ConvertedChildren
FROM project.dbo.hotel_bookings

UPDATE project.dbo.hotel_bookings
SET children = cast(replace(children, 'NA','0') AS float )

ALTER TABLE project.dbo.hotel_bookings
ADD ConvertedChildren float;

UPDATE project.dbo.hotel_bookings
SET ConvertedChildren = cast(replace(children, 'NA','0') AS float )


--Babies
SELECT CAST(babies AS float) as convertedBabies
FROM project.dbo.hotel_bookings

UPDATE project.dbo.hotel_bookings
SET babies = CAST(babies AS float)

ALTER TABLE Project.dbo.hotel_bookings
ADD ConvertedBabies float;

UPDATE project.dbo.hotel_bookings
SET ConvertedBabies = cast(babies AS float)

SELECT*
FROM Project.dbo.hotel_bookings

--is_canceled Column Formatting//Cheking For NULLs First
SELECT is_canceled
FROM project.dbo.hotel_bookings
WHERE is_canceled = 'null'
--Ther is no null value in this column

SELECT CAST(is_canceled AS float ) AS ConvertedIs_canceled
FROM project.dbo.hotel_bookings

UPDATE project.dbo.hotel_bookings
SET is_canceled = CAST(is_canceled AS float )

ALTER TABLE project.dbo.hotel_bookings
ADD new_is_canceled float;

UPDATE project.dbo.hotel_bookings
SET new_is_canceled = CAST(is_canceled AS float )

SELECT*
FROM project.dbo.hotel_bookings

--Verifying Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY country,
				 ConvertedAdults,
				 ConvertedChildren,
				 ConvertedBabies,
				 hotel,
				 con_reservation_status_date,
				 new_is_Canceled,
				 reservation_status,
				 ArrivalDate,
				 is_repeated_guest,
				 deposit_type, 
				 new_is_canceled,
				 lead_time,
				 meal,
				 market_segment,
				 distribution_channel,
				 booking_changes,
				 agent,
				 company,
				 assigned_room_type,
				 reserved_room_type, 
				 days_in_waiting_list,
				 required_car_parking_spaces,
				 total_of_special_requests,
				 customer_type,
				 adr,
				 stays_in_weekend_nights,
				 stays_in_week_nights,
				 arrival_date_week_number,
				 previous_cancellations,
				 previous_bookings_not_canceled
				 ORDER BY
				 country,
				 ArrivalDate
					) row_num
From Project.dbo.hotel_bookings
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY ArrivalDate

--Deleting Unused Columns/
--The columns I deleted were in wrong formatting and I have created the same columns with the right format in the table

SELECT*
FROM project.dbo.hotel_bookings

ALTER TABLE Project.dbo.hotel_bookings
DROP COLUMN adults, children, babies, is_canceled
ALTER TABLE Project.dbo.hotel_bookings
DROP COLUMN reservation_status_date

