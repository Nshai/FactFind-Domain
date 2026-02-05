SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveDiscountForAdviseFeeChargingDetails]

@TenantId BIGINT

AS

SELECT Discount.DiscountId AS DiscountId
, Discount.Name AS DiscountName
, Discount.Amount AS DiscountAmount
, Discount.Percentage AS DiscountPercentage
, ISNULL(Discount.Reason, '') AS DiscountReason
, Discount.IsArchived AS IsArchived 
FROM TDiscount Discount 

WHERE Discount.TenantId = @TenantId 
AND Discount.IsArchived = 0