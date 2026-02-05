SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SpNAuditIndigoClientPreferenceCombined]   
@StampUser varchar (255),  
 @IndigoClientPreferenceCombinedId uniqueidentifier,   
 @StampAction char(1)  AS  
 
  
INSERT INTO TIndigoClientPreferenceCombinedAudit
                      (IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, ConcurrencyId, msrepl_tran_version, Guid,
                       StampAction, StampDateTime, StampUser)
SELECT     IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, ConcurrencyId, msrepl_tran_version, Guid, @StampAction AS Expr1, 
                      GETDATE() AS Expr2, @StampUser AS Expr3
FROM         TIndigoClientPreferenceCombined
WHERE     (Guid = @IndigoClientPreferenceCombinedId)
GO
