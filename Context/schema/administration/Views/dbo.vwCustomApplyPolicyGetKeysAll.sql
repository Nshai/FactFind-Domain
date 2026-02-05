CREATE VIEW dbo.vwCustomApplyPolicyGetKeysAll AS 

SELECT * FROM dbo.vwCustomApplyPolicyGetKeys
UNION
SELECT * FROM dbo.VwCustomApplyPolicyGetKeysWithoutPropogation

GO
