SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessTransaction]
	@StampUser varchar (255),
	@PolicyBusinessTransactionId bigint,
	@StampAction char(1)
AS
BEGIN
	DECLARE @delete char(1) = 'D';
	DECLARE @update char(1) = 'U';

	--
	-- We are only auditing Updates and Deletes
	--
	IF(@StampAction NOT IN (@delete, @update))
		RETURN(0)

	BEGIN TRY
		--
		-- For an Update we are simply updating the UpdatedAt field on the original record
		--
		IF(@StampAction = @update)
		BEGIN
			UPDATE TPolicyBusinessTransaction
			SET 
				 UpdatedAt = GetUtcDate()
				,UpdatedByUserId = @StampUser
			WHERE
				PolicyBusinessTransactionId = @PolicyBusinessTransactionId
		END
		ELSE
		BEGIN
			INSERT INTO TPolicyBusinessTransactionAudit 
			( 
				 [PolicyBusinessTransactionId]
				,[TenantId]
				,[PolicyBusinessId]
				,[PolicyBusinessFundId]
				,[TransactionDate]
				,[Source]
				,[BaseType]
				,[EntryType]
				,[Description]
				,[Gross]
				,[Cost]
				,[UnitPrice]
				,[UnitQuantity]
				,[Category1Text]
				,[Category1Code]
				,[Category2Text]
				,[Category2Code]
				,[PaymentFrom]
				,[PaymentTo]
				,[Frequency]
				,[Reference]
				,[IsRestricted]
				,[RefFundTransactionTypeId]
				,[IsFromTransactionHistory]
				,[MigrationReference]
				,[CreatedByUserId]
				,[CreatedByAppId]
				,[CreatedByAppName]
				,[CreatedAt]
				,[UpdatedAt]
				,[UpdatedByUserId]
				,[StampAction]
				,[StampDateTime]
				,[StampUser]
			)
			SELECT 
				 [PolicyBusinessTransactionId]
				,[TenantId]
				,[PolicyBusinessId]
				,[PolicyBusinessFundId]
				,[TransactionDate]
				,[Source]
				,[BaseType]
				,[EntryType]
				,[Description]
				,[Gross]
				,[Cost]
				,[UnitPrice]
				,[UnitQuantity]
				,[Category1Text]
				,[Category1Code]
				,[Category2Text]
				,[Category2Code]
				,[PaymentFrom]
				,[PaymentTo]
				,[Frequency]
				,[Reference]
				,[IsRestricted]
				,[RefFundTransactionTypeId]
				,[IsFromTransactionHistory]
				,[MigrationReference]
				,[CreatedByUserId]
				,[CreatedByAppId]
				,[CreatedByAppName]
				,[CreatedAt]
				,[UpdatedAt]
				,[UpdatedByUserId]
				,@StampAction
				,GetUtcDate()
				,@StampUser 
			FROM 
				TPolicyBusinessTransaction
			WHERE 
				PolicyBusinessTransactionId = @PolicyBusinessTransactionId
		END
		
		RETURN (0);
		
	END TRY
	BEGIN CATCH	
		RETURN (100)
	END CATCH;

END
GO
