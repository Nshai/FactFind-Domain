SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveFeeModelByFeeModelTemplateId] 

@FeeModelTemplateId BIGINT

AS

SELECT FM.FeeModelId AS FeeModelId
      ,FM.Name AS FeeModelName

  FROM PolicyManagement..TFeeModelTemplate FMT
  INNER JOIN PolicyManagement..TFeeModel FM ON FM.FeeModelId = FMT.FeeModelId
  WHERE  FMT.FeeModelTemplateId = @FeeModelTemplateId
GO
