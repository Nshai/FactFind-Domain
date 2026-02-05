SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveDiscountByFeeModelTemplateId]

@FeeModelTemplateId BIGINT,
@TenantId BIGINT

AS

SELECT Discount.DiscountId AS DiscountId
, Discount.Name AS DiscountName
, Discount.Amount AS DiscountAmount
, Discount.Percentage AS DiscountPercentage
, ISNULL(Discount.Reason, '') AS DiscountReason
, Discount.IsArchived AS IsArchived 
FROM TFeeModelTemplateToDiscount TemplateDiscount 
INNER JOIN TFeeModelTemplate Template ON TemplateDiscount.FeeModelTemplateId=Template.FeeModelTemplateId 
INNER JOIN TDiscount Discount ON TemplateDiscount.DiscountId=Discount.DiscountId 

WHERE Template.FeeModelTemplateId = @FeeModelTemplateId 
AND TemplateDiscount.TenantId = @TenantId 
AND Discount.IsArchived = 0