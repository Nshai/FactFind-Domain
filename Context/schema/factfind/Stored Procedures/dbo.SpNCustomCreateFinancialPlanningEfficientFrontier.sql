SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinancialPlanningEfficientFrontier]
	@FinancialPlanningId bigint,
	@ChartUrl varchar(255), 
	@Data varchar(max), 
	@ChartDefinition varchar(1000),
	@OriginalReturn decimal(18,7), 
	@OriginalRisk decimal(18,7), 
	@CurrentReturn decimal(18,7), 
	@CurrentRisk decimal(18,7),
	@Term int,
	@StampUser varchar(50)
AS
DECLARE @FinancialPlanningEfficientFrontierId bigint

SELECT @FinancialPlanningEfficientFrontierId = FinancialPlanningEfficientFrontierId
FROM  TFinancialPlanningEfficientFrontier
WHERE @FinancialPlanningId = FinancialPlanningId

IF (@FinancialPlanningEfficientFrontierId is null) begin
	INSERT INTO TFinancialPlanningEfficientFrontier (
		FinancialPlanningId, ChartUrl, Data, OriginalReturn, OriginalRisk, CurrentReturn, CurrentRisk, Term, ChartDefinition, ConcurrencyId)
	SELECT 
		@FinancialPlanningId, @ChartUrl, @Data, @OriginalReturn, @OriginalRisk, @CurrentReturn, @CurrentRisk, @Term, @ChartDefinition, 1

	SELECT @FinancialPlanningEfficientFrontierId = SCOPE_IDENTITY()

	EXEC SpNAuditFinancialPlanningEfficientFrontier @StampUser,@FinancialPlanningEfficientFrontierId,'C'
END
ELSE BEGIN
	EXEC SpNAuditFinancialPlanningEfficientFrontier @StampUser,@FinancialPlanningEfficientFrontierId,'U'

	UPDATE TFinancialPlanningEfficientFrontier
	SET		ChartUrl = @ChartUrl,
			Data = @Data,
			ChartDefinition = @ChartDefinition,
			OriginalReturn = @OriginalReturn,
			OriginalRisk = @OriginalRisk,
			CurrentReturn = @CurrentReturn,
			CurrentRisk = @CurrentRisk,
			Term = @Term,
			ConcurrencyId = ConcurrencyId + 1
	WHERE @FinancialPlanningEfficientFrontierId = FinancialPlanningEfficientFrontierId
END
GO
