CREATE FUNCTION [dbo].[NewCombGuid] ()
RETURNS [uniqueidentifier]
WITH EXECUTE AS CALLER
EXTERNAL NAME [GuidCombGeneratorUdf].[GuidCombUdf].[Generate]
GO
