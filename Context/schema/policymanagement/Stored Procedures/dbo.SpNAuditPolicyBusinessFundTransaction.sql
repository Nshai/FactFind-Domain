SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessFundTransaction]
	@StampUser VARCHAR(255),
	@PolicyBusinessFundTransactionId BIGINT,
	@StampAction CHAR(1)
AS
BEGIN
	--
	-- NOTE this is only called from IO which handles the transaction
	-- we just need to make sure we return 100 if something goes wrong
	--
	BEGIN TRY
		IF @StampAction = 'U'
			UPDATE TPolicyBusinessFundTransaction
			SET UpdatedAt = GetUtcDate(),
				UpdatedByUserId = @StampUser
			WHERE PolicyBusinessFundTransactionId = @PolicyBusinessFundTransactionId

		INSERT INTO TPolicyBusinessFundTransactionAudit (
			PolicyBusinessFundId,
			TransactionDate,
			RefFundTransactionTypeId,
			Gross,
			Cost,
			UnitPrice,
			UnitQuantity,
			ConcurrencyId,
			PolicyBusinessFundTransactionId,
			MigrationReference,
			StampAction,
			StampDateTime,
			StampUser,
			IsFromTransactionHistory,
			[Description],
			[TenantId],
  			PolicyBusinessId,
  			BaseType,
  			EntryType,
  			Category1Text,
  			Category1Code,
  			Category2Text,
  			Category2Code,
  			PaymentFrom,
  			PaymentTo,
  			Frequency,
  			Reference,
  			IsRestricted,
  			CreatedAt,
  			CreatedByUserId,
  			CreatedByAppId,
  			CreatedByAppName,
  			UpdatedAt,
  			UpdatedByUserId
			)
		SELECT PolicyBusinessFundId,
			TransactionDate,
			RefFundTransactionTypeId,
			Gross,
			Cost,
			UnitPrice,
			UnitQuantity,
			ConcurrencyId,
			PolicyBusinessFundTransactionId,
			MigrationReference,
			@StampAction,
			GetDate(),
			@StampUser,
			IsFromTransactionHistory,
			[Description],
			[TenantId],
  			PolicyBusinessId,
  			BaseType,
  			EntryType,
  			Category1Text,
  			Category1Code,
  			Category2Text,
  			Category2Code,
  			PaymentFrom,
  			PaymentTo,
  			Frequency,
  			Reference,
  			IsRestricted,
  			CreatedAt,
  			CreatedByUserId,
  			CreatedByAppId,
  			CreatedByAppName,
  			UpdatedAt,
  			UpdatedByUserId
		FROM TPolicyBusinessFundTransaction
		WHERE PolicyBusinessFundTransactionId = @PolicyBusinessFundTransactionId

		RETURN (0)
	END TRY

	BEGIN CATCH
		RETURN (100)
	END CATCH
END
GO


