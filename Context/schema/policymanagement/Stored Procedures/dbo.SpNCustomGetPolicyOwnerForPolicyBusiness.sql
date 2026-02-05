SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPolicyOwnerForPolicyBusiness] @PolicyBusinessId bigint
AS


SELECT  TOP 1 C.CRMContactId
	
FROM TPolicyBusiness  A
JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId
JOIN TPolicyOwner C ON B.PolicyDetailId=C.PolicyDetailId
WHERE A.PolicyBusinessId=@PolicyBusinessId
ORDER BY C.PolicyOwnerId
GO
