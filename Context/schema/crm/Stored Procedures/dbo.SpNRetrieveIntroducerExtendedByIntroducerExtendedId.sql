SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveIntroducerExtendedByIntroducerExtendedId]
	@IntroducerExtendedId bigint
AS

SELECT T1.IntroducerExtendedId, T1.IntroducerId, T1.MigrationRef, T1.ConcurrencyId
FROM TIntroducerExtended  T1
WHERE T1.IntroducerExtendedId = @IntroducerExtendedId
GO
