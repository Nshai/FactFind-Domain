SET QUOTED_IDENTIFIER OFF;
GO
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE [dbo].[SpCustomUpdatePoliciesFoundForFirmAndProvider] @ValScheduleId BIGINT
AS

     --25/02/2008: Added code to cater for Matching Criteria via TValBulkConfig
     --23/10/2008: Modified for speed
     --11/02/2009: Modified step 5 (added ValBulkHoldingId range) - current process caused temp db to run out of space
     --to check space: xp_fixeddrives (monitor I drive)

     --TRAC 2185 Begins
     --19th July 2010 : Matching Block ie |6| for Quilter added - this was required since 
     --quilter wanted to do the matchin only on policy number
     --By : KK
     --TRAC 2185 Ends

     --31/08/2010: Modified to Account for Sub Plans 
     -- i.e. we will have dupllicate Portfolio records so ignore records with sub plan data

     --13/05/2010 : Introduced new criteria for Ascentric on Planreference+Portalreference by KK - Trac Ticket 2822
     --03/10/2012 : Fidelity going for bundled plans AME-1594 - KK

     --30/08/2012 : Introduced new criteria '|16|' for L&G on policy number and AdviserReference - NB: AdviserReference is for the ServicingAdviser

/*
Matching Criteria

1 Match on Policy number ONLY
2 Match portal reference (Cofunds Customer Reference) And policy number (Cofunds Portfolio Reference) 
3 Match the Client on the Cofunds Customer Reference and Plan Type
4 Match the Client on National Insurance Number - Individual and Plan Type
5 Match the Client on Surname, DOB and Postcode - Individual and Plan Type
6 Match the Policy Number - QUILTER
7 Match on SubPlan Number - QUILTER - to be added for any provider that support sub plans
8 Match the Policynumber and Portalreference - ASCENTRIC
16 Match on PolicyNumber and AdviserReference - L&G NB: AdviserReference is from CRM..TAgencyNumber 

Current settings 31/08/2010

Cofunds:	|2|3|4|5|
Fidelity:	|1|
Quilter:	|6|7|
Ascentric   |8|
Raymond James   |9|
Brooks Macdonald   |10|  -Strip zeros to left
Margetts   |11|  -Strip  zeros to left, strip Spaces while matching policy number + match the portal ref number
Aviva   Wrap - |15|
*/

     SET NOCOUNT ON;

     --test  
     --declare @ValScheduleId bigint    
     --Set @ValScheduleId = 12734   
     DECLARE @ActionTime DATETIME = GETDATE();
     DECLARE @RefProdProviderId BIGINT,
             @IndigoClientId BIGINT,
             @MatchingCriteria VARCHAR( 255 );
     DECLARE @MaxValBulkHoldingId BIGINT,
             @MinValBulkHoldingId BIGINT,
             @ValScheduleItemId BIGINT;

/*
I think @MaxValBulkHoldingId & @MinValBulkHoldingId should be replaced with @ValScheduleItemId but for now do not want to cause any regression issues hence leaving it - TO DO
Also I think re-creating the index in the entire SP requires to be re-visited.  At least it doesn't have to re-created for every provider - To Do later especialy iff we are moving to DAILY for Bulk File
*/

     SELECT @RefProdProviderId = RefProdProviderId,
            @IndigoClientId = IndigoClientId
       FROM PolicyManagement..TValSchedule WITH ( nolock )
       WHERE ValScheduleId = @ValScheduleId;

     --Get Matching Criteria
     SELECT @MatchingCriteria = MatchingCriteria
       FROM PolicyManagement..TValBulkConfig WITH ( nolock )
       WHERE RefProdProviderId = @RefProdProviderId;

     --Get BulkHoldingIds
     SELECT @MaxValBulkHoldingId = MAX( ValBulkHoldingId ),
            @MinValBulkHoldingId = MIN( ValBulkHoldingId ),
            @ValScheduleItemId = MAX( B.ValScheduleItemID )
       FROM PolicyManagement..TValBulkHolding A WITH ( nolock )
            INNER JOIN PolicyManagement..TValScheduleItem B WITH ( nolock )
              ON A.ValScheduleItemID = B.ValScheduleItemID
       WHERE B.ValScheduleId = @ValScheduleId;

     --Identify records that have the same NI number against different clients  
     --we need to ignore these  
     IF OBJECT_ID( N'tempdb..#BulkHoldingFileErrors',N'U' ) IS NOT NULL
         DROP TABLE #BulkHoldingFileErrors;

     CREATE TABLE #BulkHoldingFileErrors( DuplicateNINumbers VARCHAR( 20 ) PRIMARY KEY );

     INSERT INTO #BulkHoldingFileErrors( DuplicateNINumbers )
     --2) Identify the key duplicates   
     SELECT NINumber--, NoofDuplictaes = count(*)  
       FROM(
           --1) group the data first  
           SELECT CustomerReference,
                  NINumber
             FROM PolicyManagement..TValBulkHolding WITH ( NOLOCK )
             WHERE ISNULL( NINumber,'' ) <> ''
               AND IsLatestFg = 0
               AND ValScheduleItemId = @ValScheduleItemId
             GROUP BY CustomerReference,
                      NINumber ) T1
       GROUP BY NINumber
       HAVING COUNT( * ) > 1;

     --insert policybusinessid mapping into table - then delete any policybusinessid's that are duplicated  
     --the reason for this if a client in the file has two sipp's but only one sipp is in IO which record in the file is the correct one?  
     IF OBJECT_ID( 'TPolicyBusinessMappingBulk' ) IS NOT NULL
         BEGIN
             DROP TABLE dbo.TPolicyBusinessMappingBulk;
         END;

     CREATE TABLE dbo.TPolicyBusinessMappingBulk( PolicyBusinessId BIGINT,
                                                  PortfolioReference VARCHAR( 255 ), --maps to IO PolicyNumber  
                                                  CustomerReference VARCHAR( 255 ), --maps to IO PortalReference  
                                                  PassReference VARCHAR( 50 ), --used to identify what critria picked up the policybusinessid
                                                  ParentPolicyBusinessId BIGINT );
     EXEC sp_changeobjectowner
          'TPolicyBusinessMappingBulk',
          'dbo';

     IF EXISTS( SELECT name
                  FROM sysindexes
                  WHERE name = 'IDX_TPolicyBusinessMapping_PolicyBusinessId' )
         DROP INDEX TPolicyBusinessMappingBulk.IDX_TPolicyBusinessMapping_PolicyBusinessId;

     CREATE INDEX IDX_TPolicyBusinessMapping_PolicyBusinessId ON TPolicyBusinessMappingBulk( PolicyBusinessId );
     CREATE INDEX IDX_TPolicyBusinessMapping_PortfolioReference ON TPolicyBusinessMappingBulk( PortfolioReference );

     --Process Matching Criteria
     IF CHARINDEX( '|1|',@MatchingCriteria ) > 0
         BEGIN
             CREATE TABLE #FidelityPlans( Id BIGINT IDENTITY( 1,1 ),
                                          IndigoClientId BIGINT,
                                          PolicyBusinessId BIGINT,
                                          RefPlanTypeId BIGINT,
                                          PolicyNumber VARCHAR( 255 ),
                                          PolicyStartDate DATETIME,
                                          TaxYear VARCHAR( 5 ),
                                          MatchingPolicyNumber VARCHAR( 255 ));

             --Select ISAs and PEPs
             INSERT INTO #FidelityPlans( IndigoClientId,
                                         PolicyBusinessId,
                                         RefPlanTypeId,
                                         PolicyNumber,
                                         PolicyStartDate,
                                         TaxYear )
             SELECT T1.IndigoClientId,
                    T4.PolicyBusinessId,
                    D.RefPlanTypeId,
                    PolicyNumber = CASE
                                   WHEN CHARINDEX( '/',T4.PolicyNumber ) > 0 THEN LEFT( T4.PolicyNumber,CHARINDEX( '/',T4.PolicyNumber ) - 1 )
                                       ELSE T4.PolicyNumber
                                   END,
                    T4.PolicyStartDate,
                    TaxYear = CASE
                              WHEN PBExt.PortalReference LIKE '%/bundled%' THEN NULL
                                  ELSE CASE
                                       WHEN(CONVERT( DATETIME,T4.PolicyStartDate,126 ) < CONVERT( DATETIME,CONVERT( VARCHAR( 10 ),DATEPART( yyyy,T4.PolicyStartDate )) + '-04-06',126 )) THEN CONVERT( VARCHAR( 10 ),DATEPART( yyyy,T4.PolicyStartDate ) - 1 )
                                           ELSE CONVERT( VARCHAR( 10 ),DATEPART( yyyy,T4.PolicyStartDate ))
                                       END
                              END
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt PBExt WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = PBExt.PolicyBusinessId --IO Plan Type Mapping  
                    INNER JOIN Policymanagement..TPolicyDetail b WITH ( NOLOCK )
                      ON T4.PolicyDetailId = b.PolicyDetailId
                    INNER JOIN Policymanagement..TPlanDescription c WITH ( NOLOCK )
                      ON b.PlanDescriptionid = c.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType d WITH ( NOLOCK )
                      ON c.RefPlanType2ProdSubTypeid = d.RefPlanType2ProdSubTypeId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId

                     --Filter on ISA and PEPs ONLY and MUST have PolicyStartDate
                 AND d.RefPlanTypeId IN( 31,32 )
                 AND T4.PolicyStartDate IS NOT NULL
               GROUP BY T1.IndigoClientId,
                        T4.PolicyBusinessId,
                        D.RefPlanTypeId,
                        T4.PolicyNumber,
                        T4.PolicyStartDate,
                        PBExt.PortalReference;

             --Select Other Plans
             INSERT INTO #FidelityPlans( IndigoClientId,
                                         PolicyBusinessId,
                                         RefPlanTypeId,
                                         PolicyNumber,
                                         PolicyStartDate,
                                         TaxYear )
             SELECT T1.IndigoClientId,
                    T4.PolicyBusinessId,
                    D.RefPlanTypeId,
                    PolicyNumber = CASE
                                   WHEN CHARINDEX( '/',T4.PolicyNumber ) > 0 THEN LEFT( T4.PolicyNumber,CHARINDEX( '/',T4.PolicyNumber ) - 1 )
                                       ELSE T4.PolicyNumber
                                   END,
                    T4.PolicyStartDate,
                    NULL
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId --IO Plan Type Mapping  
                    INNER JOIN Policymanagement..TPolicyDetail b WITH ( NOLOCK )
                      ON T4.PolicyDetailId = b.PolicyDetailId
                    INNER JOIN Policymanagement..TPlanDescription c WITH ( NOLOCK )
                      ON b.PlanDescriptionid = c.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType d WITH ( NOLOCK )
                      ON c.RefPlanType2ProdSubTypeid = d.RefPlanType2ProdSubTypeId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId

                     --Exclude ISA and PEPs ONLY
                 AND d.RefPlanTypeId NOT IN( 31,32 )
               GROUP BY T1.IndigoClientId,
                        T4.PolicyBusinessId,
                        D.RefPlanTypeId,
                        T4.PolicyNumber,
                        T4.PolicyStartDate;

             --Update correct Matching Policy Number for ISAs and PEPs
             UPDATE #FidelityPlans
               SET MatchingPolicyNumber = CASE
                                          WHEN RefPlanTypeId IN( 31,32 ) THEN CASE
                                                                              WHEN TaxYear IS NOT NULL THEN PolicyNumber + '/' + TaxYear
                                                                                  ELSE PolicyNumber
                                                                              END
                                              ELSE PolicyNumber
                                          END;

             --test
             --select *from #FidelityPlans

             --Do the matching against the filtered plans in #FidelityPlans
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|1|'--, T4.PolicyNumber + '/' + Convert(varchar(10), datepart(yyyy, IsNull(T4.PolicyStartDate,'')) )
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN #FidelityPlans T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T4.MatchingPolicyNumber = T6.PortfolioReference
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''

                     --Exclude plans already identified  
                 AND T2.PolicyBusinessId NOT IN( 
                                                 SELECT PolicyBusinessId
                                                   FROM TPolicyBusinessMappingBulk
                                                   GROUP BY PolicyBusinessId )
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;

         END;

/*
--test
select * from TPolicyBusinessMappingBulk
return
*/

     IF CHARINDEX( '|2|',@MatchingCriteria ) > 0
         BEGIN

             --  '#' 1st pass - Plan matching  
             --  '#' Match portal reference (Cofunds Customer Reference)  
             --  '#' And policy number (Cofunds Portfolio Reference)  
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|2|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt T5 WITH ( NOLOCK )
                      ON T4.PolicyBusinessId = T5.PolicyBusinessId
                     AND T5.PortalReference IS NOT NULL
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T5.PortalReference = T6.CustomerReference
                 AND T4.PolicyNumber = T6.PortfolioReference
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;

         END;

     IF CHARINDEX( '|3|',@MatchingCriteria ) > 0
         BEGIN

             --  '#' 2nd pass - Client & plan type matching  
             --  '#' Match the Client on the Cofunds Customer Reference  
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|3|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt T5 WITH ( NOLOCK )
                      ON T4.PolicyBusinessId = T5.PolicyBusinessId
                     AND T5.PortalReference IS NOT NULL
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId --IO Plan Type Mapping  
                    INNER JOIN Policymanagement..TPolicyDetail b WITH ( NOLOCK )
                      ON T4.PolicyDetailId = b.PolicyDetailId
                    INNER JOIN Policymanagement..TPlanDescription c WITH ( NOLOCK )
                      ON b.PlanDescriptionid = c.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType d WITH ( NOLOCK )
                      ON c.RefPlanType2ProdSubTypeid = d.RefPlanType2ProdSubTypeId --Provider Plan Type Mapping  
                    INNER JOIN Policymanagement..TValGating valGating WITH ( NOLOCK )
                      ON valGating.RefProdProviderId = T1.RefProdProviderId
                     AND valGating.RefPlanTypeId = d.RefPlanTypeid --Exclude plans already identified
                    LEFT JOIN TPolicyBusinessMappingBulk temp
                      ON temp.PortfolioReference = T6.PortfolioReference
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T4.IndigoClientId = @IndigoClientId
                 AND b.IndigoClientId = @IndigoClientId
                 AND T5.PortalReference = T6.CustomerReference
                 AND T6.IsLatestFg = 0

                     --Plan type mapping  
                 AND ISNULL( valGating.ProdSubTypeId,0 ) = ISNULL( d.ProdSubTypeId,0 )
                 AND ISNULL( valGating.ProviderPlanTypeName,'' ) = T6.PortfolioType

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''

                     --Exclude plans already identified  
                     --	And temp.PolicyBusinessId is null
                 AND temp.PortfolioReference IS NULL
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;

         END;

/*
--Test
select PassReference, count(*)
from TPolicyBusinessMappingBulk 
group by PassReference

return
*/

     IF CHARINDEX( '|4|',@MatchingCriteria ) > 0
         BEGIN

             --  '#' 3rd pass - client & plan type matching  
             --  '#' a) First Match: National Insurance Number - Individual  
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|4|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
                     AND ISNULL( T6.NINumber,'' ) <> '' --IO Client Mapping  
                    INNER JOIN PolicyManagement..TPolicyOwner T7 WITH ( NOLOCK )
                      ON T4.PolicyDetailId = T7.PolicyDetailId
                    INNER JOIN CRM..TCRMContact T8 WITH ( NOLOCK )
                      ON T7.CRMContactId = T8.CRMContactId
                    INNER JOIN CRM..TPerson T9 WITH ( NOLOCK )
                      ON T8.PersonId = T9.PersonId
                     AND ISNULL( T9.NINumber,'' ) <> '' --IO Plan Type Mapping  
                    INNER JOIN Policymanagement..TPolicyDetail b WITH ( NOLOCK )
                      ON T4.PolicyDetailId = b.PolicyDetailId
                    INNER JOIN Policymanagement..TPlanDescription c WITH ( NOLOCK )
                      ON b.PlanDescriptionid = c.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType d WITH ( NOLOCK )
                      ON c.RefPlanType2ProdSubTypeid = d.RefPlanType2ProdSubTypeId --Provider Plan Type Mapping  
                    INNER JOIN Policymanagement..TValGating valGating WITH ( NOLOCK )
                      ON valGating.RefProdProviderId = T1.RefProdProviderId
                     AND valGating.RefPlanTypeId = d.RefPlanTypeid --Exclude plans already identified
                    LEFT JOIN TPolicyBusinessMappingBulk temp
                      ON temp.PortfolioReference = T6.PortfolioReference
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T4.IndigoClientId = @IndigoClientId
                 AND T8.IndClientId = @IndigoClientId
                 AND b.IndigoClientId = @IndigoClientId
                 AND T6.IsLatestFg = 0

                     --NI mapping  
                 AND REPLACE( T9.NINumber,'-','' ) = REPLACE( T6.NINumber,'-','' )

                     --Plan type mapping  
                 AND ISNULL( valGating.ProdSubTypeId,0 ) = ISNULL( d.ProdSubTypeId,0 )
                 AND ISNULL( valGating.ProviderPlanTypeName,'' ) = T6.PortfolioType

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''

                     --Exclude plans already identified  
                     -- And temp.PolicyBusinessId is null
                 AND temp.PortfolioReference IS NULL

               --Exclude rows identified as duplicates  
               --And T6.NINumber Not In (select DuplicateNINumbers from #BulkHoldingFileErrors)    --BAU-803 extracted to a separate statement as this was causing time-out for Honister

               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;

             --BAU-803  Begins
             DELETE FROM TPolicyBusinessMappingBulk
               WHERE CustomerReference IN( SELECT CustomerReference
                                             FROM PolicyManagement..TValBulkHolding A WITH ( nolock )
                                                  INNER JOIN PolicyManagement..TValScheduleItem B WITH ( nolock )
                                                    ON A.ValScheduleItemID = B.ValScheduleItemID
                                             WHERE ISNULL( NINumber,'' ) IN( 
                                                                             SELECT DuplicateNINumbers
                                                                               FROM #BulkHoldingFileErrors )
                                               AND A.IsLatestFg = 0
                                               AND B.ValScheduleId = @ValScheduleId )
                 AND PassReference = '|4|';
         --BAU-803  Ends

         END;

/*
--Test
select PassReference, count(*)
from TPolicyBusinessMappingBulk 
group by PassReference

return
*/

     IF CHARINDEX( '|5|',@MatchingCriteria ) > 0
         BEGIN

             --  '#' 3rd pass - client & plan type matching  
             --  b) Second Match: Surname, DOB and Postcode - Individual  
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|5|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
                     AND ISNULL( T6.LastName,'' ) <> '' --IO Client Mapping  
                    INNER JOIN PolicyManagement..TPolicyOwner T7 WITH ( NOLOCK )
                      ON T4.PolicyDetailId = T7.PolicyDetailId
                    INNER JOIN CRM..TCRMContact T8 WITH ( NOLOCK )
                      ON T7.CRMContactId = T8.CRMContactId --Inner Join CRM..TPerson T9 WITH(NOLOCK) On T8.PersonId = T9.PersonId  

             --IO Address Mapping  
                    LEFT JOIN CRM..TAddress T10 WITH ( NOLOCK )
                      ON T8.CRMContactId = T10.CRMContactId
                    LEFT JOIN CRM..TAddressStore T11 WITH ( NOLOCK )
                      ON T10.AddressStoreId = T11.AddressStoreId --IO Plan Type Mapping  
                    INNER JOIN Policymanagement..TPolicyDetail b WITH ( NOLOCK )
                      ON T4.PolicyDetailId = b.PolicyDetailId
                    INNER JOIN Policymanagement..TPlanDescription c WITH ( NOLOCK )
                      ON b.PlanDescriptionid = c.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType d WITH ( NOLOCK )
                      ON c.RefPlanType2ProdSubTypeid = d.RefPlanType2ProdSubTypeId --Provider Plan Type Mapping  
                    INNER JOIN Policymanagement..TValGating valGating WITH ( NOLOCK )
                      ON valGating.RefProdProviderId = T1.RefProdProviderId
                     AND valGating.RefPlanTypeId = d.RefPlanTypeid --Exclude plans already identified
                    LEFT JOIN TPolicyBusinessMappingBulk temp
                      ON temp.PortfolioReference = T6.PortfolioReference
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T4.IndigoClientId = @IndigoClientId
                 AND T8.IndClientId = @IndigoClientId
                 AND T10.IndClientId = @IndigoClientId
                 AND T11.IndClientId = @IndigoClientId
                 AND b.IndigoClientId = @IndigoClientId
                 AND T6.ValBulkHoldingId BETWEEN @MaxValBulkHoldingId AND @MinValBulkHoldingId
                 AND T6.IsLatestFg = 0

                     --Surname & DOB mapping  
                 AND T8.LastName = T6.LastName
                 AND T8.DOB = T6.DOB

                     --Postcode mapping  
                 AND T11.Postcode = T6.ClientPostCode

                     --Plan type mapping  
                 AND ISNULL( valGating.ProdSubTypeId,0 ) = ISNULL( d.ProdSubTypeId,0 )
                 AND ISNULL( valGating.ProviderPlanTypeName,'' ) = T6.PortfolioType

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''

                     --Exclude plans already identified  
                     --	And temp.PolicyBusinessId is null
                 AND temp.PortfolioReference IS NULL
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;
         END;

/*
--test
select PassReference, count(*)
from TPolicyBusinessMappingBulk 
group by PassReference

return
*/

     --For Quilter
     IF CHARINDEX( '|6|',@MatchingCriteria ) > 0
         BEGIN
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|6|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T4.PolicyNumber = T6.PortfolioReference
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;
         END;

     --For Ascentric
     IF CHARINDEX( '|8|',@MatchingCriteria ) > 0
         BEGIN

             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    t4.Policynumber,
                    Ext.PortalReference,
                    '|8|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyDetail Det WITH ( NOLOCK )
                      ON T4.PolicyDetailId = Det.PolicyDetailId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt Ext WITH ( NOLOCK )
                      ON T4.PolicyBusinessId = Ext.PolicyBusinessId
                    INNER JOIN Policymanagement..TPlanDescription PDes WITH ( nolock )
                      ON Det.PlanDescriptionid = PDes.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType Mpt WITH ( nolock )
                      ON PDes.RefPlanType2ProdSubTypeid = Mpt.RefPlanType2ProdSubTypeId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T4.PolicyNumber = T6.CustomerReference
                 AND Ext.PortalReference = T6.PortfolioType
                 AND T6.IsLatestFg = 0
                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        t4.Policynumber,
                        Ext.PortalReference; --, Mpt.RefPlantypeId, Mpt.prodsubtypeid

         END;

     --For Raymond James
     IF CHARINDEX( '|9|',@MatchingCriteria ) > 0
         BEGIN

             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|9|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND REPLACE( T4.PolicyNumber,' ','' ) = REPLACE( T6.PortfolioReference,' ','' )
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;

         END;

     --Brooks MacDonald
     IF CHARINDEX( '|10|',@MatchingCriteria ) > 0
         BEGIN
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|10|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND RTRIM( SUBSTRING( LTRIM( T4.PolicyNumber ),PATINDEX( '%[^0]%',LTRIM( T4.PolicyNumber )),LEN( LTRIM( T4.PolicyNumber )))) = RTRIM( SUBSTRING( LTRIM( T6.PortfolioReference ),PATINDEX( '%[^0]%',LTRIM( T6.PortfolioReference )),LEN( LTRIM( T6.PortfolioReference ))))
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;
         END;

     IF CHARINDEX( '|11|',@MatchingCriteria ) > 0
         BEGIN

             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.PortfolioType,
                    '|11|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyDetail Det WITH ( NOLOCK )
                      ON T4.PolicyDetailId = Det.PolicyDetailId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt Ext WITH ( NOLOCK )
                      ON T4.PolicyBusinessId = Ext.PolicyBusinessId
                    INNER JOIN Policymanagement..TPlanDescription PDes WITH ( nolock )
                      ON Det.PlanDescriptionid = PDes.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType Mpt WITH ( nolock )
                      ON PDes.RefPlanType2ProdSubTypeid = Mpt.RefPlanType2ProdSubTypeId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND REPLACE( RTRIM( SUBSTRING( LTRIM( T4.PolicyNumber ),PATINDEX( '%[^0]%',LTRIM( T4.PolicyNumber )),LEN( LTRIM( T4.PolicyNumber )))),' ','' ) = REPLACE( RTRIM( SUBSTRING( LTRIM( T6.PortfolioReference ),PATINDEX( '%[^0]%',LTRIM( T6.PortfolioReference )),LEN( LTRIM( T6.PortfolioReference )))),' ','' )
                 AND UPPER( RTRIM( LTRIM( Ext.PortalReference ))) = UPPER( RTRIM( LTRIM( T6.PortfolioType )))
                 AND T6.IsLatestFg = 0
                     --Exclude sub plans
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.PortfolioType; --, Mpt.RefPlantypeId, Mpt.prodsubtypeid

         END;

     IF CHARINDEX( '|15|',@MatchingCriteria ) > 0
         BEGIN

             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    '|15|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TPolicyDetail Det WITH ( NOLOCK )
                      ON T4.PolicyDetailId = Det.PolicyDetailId
                    INNER JOIN PolicyManagement..TPolicyBusinessExt Ext WITH ( NOLOCK )
                      ON T4.PolicyBusinessId = Ext.PolicyBusinessId
                    INNER JOIN Policymanagement..TPlanDescription PDes WITH ( nolock )
                      ON Det.PlanDescriptionid = PDes.PlanDescriptionid
                    INNER JOIN Policymanagement..TRefPlanType2ProdSubType Mpt WITH ( nolock )
                      ON PDes.RefPlanType2ProdSubTypeid = Mpt.RefPlanType2ProdSubTypeId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND REPLACE( RTRIM( SUBSTRING( LTRIM( T4.PolicyNumber ),PATINDEX( '%[^0]%',LTRIM( T4.PolicyNumber )),LEN( LTRIM( T4.PolicyNumber )))),' ','' ) = REPLACE( RTRIM( SUBSTRING( LTRIM( T6.PortfolioReference ),PATINDEX( '%[^0]%',LTRIM( T6.PortfolioReference )),LEN( LTRIM( T6.PortfolioReference )))),' ','' )
                 AND T6.IsLatestFg = 0
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.PortfolioType; --, Mpt.RefPlantypeId, Mpt.prodsubtypeid

             UPDATE TPolicyBusinessMappingBulk
               SET ParentPolicyBusinessId = W.ParentPolicyBusinessId,
                   CustomerReference = PB.PolicyNumber
               FROM TPolicyBusinessMappingBulk b WITH ( NOLOCK )
                    JOIN TWrapperPolicyBusiness w WITH ( NOLOCK )
                      ON B.PolicyBusinessId = W.PolicyBusinessId
                    JOIN TPolicyBusiness PB WITH ( NOLOCK )
                      ON PB.PolicyBusinessId = W.ParentPolicyBusinessId;

             DELETE a
               FROM TPolicyBusinessMappingBulk a
                    JOIN TValBulkHolding b WITH ( NOLOCK )
                      ON ISNULL( a.CustomerReference,'' ) = ISNULL( b.CustomerReference,'' )
                     AND ISNULL( a.PortfolioReference,'' ) = ISNULL( b.PortfolioReference,'' )
               WHERE(LEN( RTRIM( LTRIM( ISNULL( b.PortfolioReference,'' )))) > 1
                 AND ISNULL( a.ParentPolicyBusinessId,0 ) < 1)
                AND b.ValScheduleItemId = @ValScheduleItemId;
         --WE DO not want to update any non-wrappers except what is in the file as just wrapper
         END;

     --Subplan matching
     IF CHARINDEX( '|7|',@MatchingCriteria ) > 0
         BEGIN
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )
             SELECT T2.PolicyBusinessId,
                    T6.SubPlanReference,
                    T6.CustomerReference,
                    '|7|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND RTRIM( LTRIM( T4.PolicyNumber )) = RTRIM( LTRIM( T6.SubPlanReference ))
                 AND T6.IsLatestFg = 0

                     --Map sub plans Only
                 AND ISNULL( T6.SubPlanType,'' ) <> ''
               GROUP BY T2.PolicyBusinessId,
                        T6.SubPlanReference,
                        T6.CustomerReference;
         END;

     -- FOR L&G - Match on PolicyNumner and/or Servicing Adviser
     IF CHARINDEX( '|16|',@MatchingCriteria ) > 0
         BEGIN
             INSERT INTO TPolicyBusinessMappingBulk( PolicyBusinessId,
                                                     PortfolioReference,
                                                     CustomerReference,
                                                     PassReference )

             --Where AdviserReference Data is not empty - L&G/TSPP
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|16|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
                     AND ISNULL( T6.AdviserReference,'' ) <> '' --IO Servicing Adviser Mapping
                    INNER JOIN PolicyManagement..TPolicyOwner T7 WITH ( NOLOCK )
                      ON T4.PolicyDetailId = T7.PolicyDetailId
                    INNER JOIN CRM..TCRMContact T8 WITH ( NOLOCK )
                      ON T7.CRMContactId = T8.CRMContactId
                    INNER JOIN CRM..TPractitioner T9 WITH ( NOLOCK )
                      ON T9.CRMContactId = T8.CurrentAdviserCRMId --IO Adviser > Agency Numbers Mapping
                    INNER JOIN CRM..TAgencyNumber T10 WITH ( NOLOCK )
                      ON T10.PractitionerId = T9.PractitionerId
                     AND T10.RefProdProviderId = 199
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T4.PolicyNumber = T6.PortfolioReference
                 AND T6.IsLatestFg = 0
                 AND T6.AdviserReference = T10.AgencyNumber

                     --Exclude sub plans  
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference
             UNION ALL

             --Where AdviserReference Data is empty - NBS
             SELECT T2.PolicyBusinessId,
                    T6.PortfolioReference,
                    T6.CustomerReference,
                    '|16|'
               FROM PolicyManagement..TValSchedule T1 WITH ( NOLOCK )
                    INNER JOIN PolicyManagement..TValSchedulePolicy T2 WITH ( NOLOCK )
                      ON T1.ValScheduleId = T2.ValScheduleId
                    INNER JOIN PolicyManagement..TValScheduleItem T3 WITH ( NOLOCK )
                      ON T2.ValScheduleId = T3.ValScheduleId
                    INNER JOIN PolicyManagement..TPolicyBusiness T4 WITH ( NOLOCK )
                      ON T2.PolicyBusinessId = T4.PolicyBusinessId
                    INNER JOIN PolicyManagement..TValBulkHolding T6 WITH ( NOLOCK )
                      ON T3.ValScheduleItemId = T6.ValScheduleItemId
                     AND ISNULL( T6.AdviserReference,'' ) = ''
               WHERE T1.ValScheduleId = @ValScheduleId
                 AND T1.IndigoClientId = T4.IndigoClientId
                 AND T4.PolicyNumber = T6.PortfolioReference
                 AND T6.IsLatestFg = 0

                     --Exclude sub plans  
                 AND ISNULL( T6.SubPlanType,'' ) = ''
               GROUP BY T2.PolicyBusinessId,
                        T6.PortfolioReference,
                        T6.CustomerReference;
         END;

     --Delete duplicate policybusinessid's  
     DELETE FROM TPolicyBusinessMappingBulk
       WHERE PolicyBusinessId IN( SELECT PolicyBusinessId
                                    FROM TPolicyBusinessMappingBulk
                                    GROUP BY PolicyBusinessId
                                    HAVING COUNT( * ) > 1 );

     --Test
     --select * from TPolicyBusinessMappingBulk  
     IF(CHARINDEX( '|8|',@MatchingCriteria ) > 0)
    OR (CHARINDEX( '|11|',@MatchingCriteria ) > 0)
         BEGIN
             DELETE FROM TPolicyBusinessMappingBulk
               WHERE PolicyBusinessId IN( SELECT T1.PolicyBusinessId
                                            FROM TPolicyBusinessMappingBulk T1
                                                 INNER JOIN TPolicyBusinessMappingBulk T2
                                                   ON T1.PortfolioReference = T2.PortfolioReference
                                                  AND T1.CustomerReference = T2.CustomerReference
                                            GROUP BY T1.PolicyBusinessId
                                            HAVING COUNT( * ) > 1 );
         END;
     ELSE
         BEGIN
             --Delete plans where the same PortfolioReference is assigned/identified as mapped to (based on plan type search) to different PolicyBusinessId's
             --This is to ensure we don't update multiple plan records 
             -- e.g. where the users have added different plans with the same plan number but different start dates
             --OR different plan numbers (e.g plan number/plan year) but the same plan types
             DELETE FROM TPolicyBusinessMappingBulk
               WHERE PortfolioReference IN( SELECT PortfolioReference --, min(PolicyBusinessId), max(PolicyBusinessId)
                                              FROM TPolicyBusinessMappingBulk
                                              GROUP BY PortfolioReference
                                              HAVING MIN( PolicyBusinessId ) <> MAX( PolicyBusinessId ));
         END;
     --####### Update main tables code from here on ####### --

     --Update IO PortalReference (with CustomerReference) in TpolicyBusinessExt for the 3rd Pass - NI Match & 3rd Pass Name Match  
     UPDATE T1
       SET T1.PortalReference = SelectedPlans.CustomerReference,
           T1.ConcurrencyId = T1.ConcurrencyId + 1
     OUTPUT DELETED.PolicyBusinessId,
            DELETED.BandingTemplateId,
            DELETED.MigrationRef,
            DELETED.PortalReference,
            DELETED.ConcurrencyId,
            DELETED.PolicyBusinessExtId,
            DELETED.IsVisibleToClient,
            DELETED.IsVisibilityUpdatedByStatusChange,
			DELETED.WhoCreatedUserId,
            'U',
            @ActionTime,
            '0',
            DELETED.QuoteId
            INTO TPolicyBusinessExtAudit( PolicyBusinessId,
                                          BandingTemplateId,
                                          MigrationRef,
                                          PortalReference,
                                          ConcurrencyId,
                                          PolicyBusinessExtId,
                                          IsVisibleToClient,
                                          IsVisibilityUpdatedByStatusChange,
										  WhoCreatedUserId,
                                          StampAction,
                                          StampDateTime,
                                          StampUser,
                                          QuoteId )
       FROM TPolicyBusinessExt T1
            INNER JOIN( SELECT PolicyBusinessId,
                               CustomerReference
                          FROM TPolicyBusinessMappingBulk
                          WHERE PassReference IN( '|4|','|5|' )
                          GROUP BY PolicyBusinessId,
                                   CustomerReference ) SelectedPlans
              ON T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId;

     --Update PolicyNumber (with PortfolioReference) in TPolicyBusiness for: 3rd Pass - NI Match, 3rd Pass Name Match, and 2nd Pass  
     UPDATE T1
       SET T1.PolicyNumber = SelectedPlans.PortfolioReference,
           T1.ConcurrencyId = T1.ConcurrencyId + 1
     OUTPUT DELETED.PolicyDetailId,
            DELETED.PolicyNumber,
            DELETED.PractitionerId,
            DELETED.ReplaceNotes,
            DELETED.TnCCoachId,
            DELETED.AdviceTypeId,
            DELETED.BestAdvicePanelUsedFG,
            DELETED.WaiverDefermentPeriod,
            DELETED.IndigoClientId,
            DELETED.SwitchFG,
            DELETED.TotalRegularPremium,
            DELETED.TotalLumpSum,
            DELETED.MaturityDate,
            DELETED.LifeCycleId,
            DELETED.PolicyStartDate,
            DELETED.PremiumType,
            DELETED.AgencyNumber,
            DELETED.ProviderAddress,
            DELETED.OffPanelFg,
            DELETED.BaseCurrency,
            DELETED.ExpectedPaymentDate,
            DELETED.ProductName,
            DELETED.InvestmentTypeId,
            DELETED.RiskRating,
            DELETED.SequentialRef,
            DELETED.ConcurrencyId,
            DELETED.PolicyBusinessId,
            'U',
            @ActionTime,
            '0'
            INTO TPolicyBusinessAudit( PolicyDetailId,
                                       PolicyNumber,
                                       PractitionerId,
                                       ReplaceNotes,
                                       TnCCoachId,
                                       AdviceTypeId,
                                       BestAdvicePanelUsedFG,
                                       WaiverDefermentPeriod,
                                       IndigoClientId,
                                       SwitchFG,
                                       TotalRegularPremium,
                                       TotalLumpSum,
                                       MaturityDate,
                                       LifeCycleId,
                                       PolicyStartDate,
                                       PremiumType,
                                       AgencyNumber,
                                       ProviderAddress,
                                       OffPanelFg,
                                       BaseCurrency,
                                       ExpectedPaymentDate,
                                       ProductName,
                                       InvestmentTypeId,
                                       RiskRating,
                                       SequentialRef,
                                       ConcurrencyId,
                                       PolicyBusinessId,
                                       StampAction,
                                       StampDateTime,
                                       StampUser )
       FROM TPolicyBusiness T1
            INNER JOIN( SELECT PolicyBusinessId,
                               PortfolioReference
                          FROM TPolicyBusinessMappingBulk
                          WHERE PassReference IN( '|4|','|5|' )
                          GROUP BY PolicyBusinessId,
                                   PortfolioReference ) SelectedPlans
              ON T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId;

     --Update policybusinessid in TValBulkholding mapping on  
     --CustomerReference (IO PortalReference) & PortfolioReference (IO Policy number)  
     --for nValScheduleId  

     --TValBulkHoldingAudit is an unnecessary overhead - Whenever we find a matching policybusinessid is updated and anything which has this not updated is not found
     --so how the auditing is helping additionally - table to be removed later
     --HENCE COMMENTING WILL REMOVE IN THE NEXT REVISION
     --Insert Into TValBulkHoldingAudit (  
     --	ValScheduleItemId,CustomerReference,PortfolioReference,CustomerSubType,FirstName,Title,LastName,CorporateName,DOB,NINumber,ClientAddressLine1,ClientAddressLine2,
     --	ClientAddressLine3,ClientAddressLine4,ClientPostCode,AdviserReference,AdviserFirstName,AdviserLastName,CompanyName,AdviserPostCode,PortfolioId,HoldingId,PortfolioType,
     --	Designation,FundProviderName,FundName,ISIN,MexId,Sedol,Quantity,EffectiveDate,Price,PriceDate,HoldingValue,Currency,WorkInProgress,CRMContactId,PractitionerId,
     --	PolicyBusinessId,Status,IsLatestFG,SubPlanReference,SubPlanType,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,AccountName,AccountReference,ConcurrencyId,
     --	ValBulkHoldingId,StampAction,StampDateTime,StampUser
     -- )  
     --Select  T1.ValScheduleItemId,T1.CustomerReference,  T1.PortfolioReference,  T1.CustomerSubType,  T1.Title,  T1.FirstName,  T1.LastName,  T1.CorporateName,  T1.DOB,  T1.NINumber,  
     --	T1.ClientAddressLine1,  T1.ClientAddressLine2,  T1.ClientAddressLine3,  T1.ClientAddressLine4,  T1.ClientPostCode,  T1.AdviserReference,  T1.AdviserFirstName,  T1.AdviserLastName,  
     --	T1.CompanyName,  T1.AdviserPostCode,  T1.PortfolioId,  T1.HoldingId,  T1.PortfolioType,  T1.Designation,  T1.FundProviderName,  T1.FundName,  T1.ISIN,  T1.MexId,  T1.Sedol,  
     --	T1.Quantity,  T1.EffectiveDate,  T1.Price,  T1.PriceDate,  T1.HoldingValue,  T1.Currency,  T1.WorkInProgress,  T1.CRMContactId,  T1.PractitionerId,  T1.PolicyBusinessId,  T1.Status,  
     --	T1.IsLatestFG,T1.SubPlanReference,T1.SubPlanType,T1.EpicCode,T1.CitiCode,T1.GBPBalance,T1.ForeignBalance,T1.AvailableCash,T1.AccountName,T1.AccountReference,
     --	T1.ConcurrencyId,  T1.ValBulkHoldingId,  'U',  @ActionTime,  '0'
     --From TValBulkHolding T1  
     --    Inner Join (  
     --     Select PolicyBusinessId, PortfolioReference, CustomerReference  
     --     From TPolicyBusinessMappingBulk  
     --     Group by PolicyBusinessId, PortfolioReference, CustomerReference  
     --     ) SelectedPlans   
     --    On IsNull(T1.CustomerReference,'') = IsNull(SelectedPlans.CustomerReference,'')
     --    And T1.PortfolioReference = SelectedPlans.PortfolioReference  
     --    And T1.IsLatestFg = 0
     --    Where IsNull(T1.SubPlanType, '') = ''k

     IF(CHARINDEX( '|8|',@MatchingCriteria ) > 0)
         BEGIN
             --Update Main Plans Found - Currently Sub Plan is not Required for Ascentric as they are not providing WRAPs. 
             UPDATE T1
               SET T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId,
                   T1.Status = 'IO Policy matched',
                   T1.ConcurrencyId = T1.ConcurrencyId + 1
               FROM TValBulkHolding T1 WITH ( NOLOCK )
                    INNER JOIN( SELECT PolicyBusinessId,
                                       PortfolioReference,
                                       CustomerReference
                                  FROM TPolicyBusinessMappingBulk
                                  GROUP BY PolicyBusinessId,
                                           PortfolioReference,
                                           CustomerReference ) SelectedPlans
                      ON ISNULL( T1.CustomerReference,'' ) = ISNULL( SelectedPlans.PortfolioReference,'' )
                     AND T1.PortfolioType = SelectedPlans.CustomerReference
               WHERE T1.ValScheduleItemId = @ValScheduleItemId
                 AND T1.IsLatestFg = 0
                 AND ISNULL( T1.SubPlanType,'' ) = '';
         END;
     ELSE
         BEGIN
             IF(CHARINDEX( '|11|',@MatchingCriteria ) > 0)
                 BEGIN
                     UPDATE T1
                       SET T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId,
                           T1.Status = 'IO Policy matched',
                           T1.ConcurrencyId = T1.ConcurrencyId + 1
                       FROM TValBulkHolding T1 WITH ( NOLOCK )
                            INNER JOIN( SELECT PolicyBusinessId,
                                               PortfolioReference,
                                               CustomerReference
                                          FROM TPolicyBusinessMappingBulk
                                          GROUP BY PolicyBusinessId,
                                                   PortfolioReference,
                                                   CustomerReference ) SelectedPlans
                              ON ISNULL( T1.PortfolioReference,'' ) = ISNULL( SelectedPlans.PortfolioReference,'' )
                             AND T1.PortfolioType = SelectedPlans.CustomerReference
                       WHERE T1.ValScheduleItemId = @ValScheduleItemId
                         AND T1.IsLatestFg = 0
                         AND ISNULL( T1.SubPlanType,'' ) = '';
                 END;
             ELSE
                 BEGIN
                     IF CHARINDEX( '|15|',@MatchingCriteria ) > 0
                         BEGIN
                             UPDATE T1
                               SET T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId,
                                   T1.Status = 'IO Policy matched',
                                   T1.ConcurrencyId = T1.ConcurrencyId + 1
                               FROM TValBulkHolding T1 WITH ( NOLOCK )
                                    INNER JOIN( SELECT PolicyBusinessId,
                                                       PortfolioReference,
                                                       CustomerReference
                                                  FROM TPolicyBusinessMappingBulk
                                                  GROUP BY PolicyBusinessId,
                                                           PortfolioReference,
                                                           CustomerReference ) SelectedPlans
                                      ON ISNULL( T1.PortfolioReference,'' ) = ISNULL( SelectedPlans.PortfolioReference,'' )
                                     AND REPLACE( RTRIM( SUBSTRING( LTRIM( T1.CustomerReference ),PATINDEX( '%[^0]%',LTRIM( T1.CustomerReference )),LEN( LTRIM( T1.CustomerReference )))),' ','' ) = REPLACE( RTRIM( SUBSTRING( LTRIM( SelectedPlans.CustomerReference ),PATINDEX( '%[^0]%',LTRIM( SelectedPlans.CustomerReference )),LEN( LTRIM( SelectedPlans.CustomerReference )))),' ','' )
                               WHERE T1.ValScheduleItemId = @ValScheduleItemId
                                 AND T1.IsLatestFg = 0;
                         END;
                     ELSE
                         BEGIN
                             --Update Main Plans Found
                             UPDATE T1
                               SET T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId,
                                   T1.Status = 'IO Policy matched',
                                   T1.ConcurrencyId = T1.ConcurrencyId + 1
                               FROM TValBulkHolding T1 WITH ( NOLOCK )
                                    INNER JOIN( SELECT PolicyBusinessId,
                                                       PortfolioReference,
                                                       CustomerReference
                                                  FROM TPolicyBusinessMappingBulk
                                                  GROUP BY PolicyBusinessId,
                                                           PortfolioReference,
                                                           CustomerReference ) SelectedPlans
                                      ON ISNULL( T1.CustomerReference,'' ) = ISNULL( SelectedPlans.CustomerReference,'' )
                                     AND T1.PortfolioReference = SelectedPlans.PortfolioReference
                               WHERE T1.ValScheduleItemId = @ValScheduleItemId
                                 AND T1.IsLatestFg = 0
                                 AND ISNULL( T1.SubPlanType,'' ) = '';

                             --Update Sub Plans Found
                             UPDATE T1
                               SET T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId,
                                   T1.Status = 'IO Policy matched',
                                   T1.ConcurrencyId = T1.ConcurrencyId + 1
                               FROM TValBulkHolding T1 WITH ( NOLOCK )
                                    INNER JOIN( SELECT PolicyBusinessId,
                                                       PortfolioReference,
                                                       CustomerReference
                                                  FROM TPolicyBusinessMappingBulk
                                                  GROUP BY PolicyBusinessId,
                                                           PortfolioReference,
                                                           CustomerReference ) SelectedPlans
                                      ON ISNULL( T1.CustomerReference,'' ) = ISNULL( SelectedPlans.CustomerReference,'' )
                                     AND T1.SubPlanReference = SelectedPlans.PortfolioReference
                               WHERE T1.ValScheduleItemId = @ValScheduleItemId
                                 AND T1.IsLatestFg = 0
                                 AND ISNULL( T1.SubPlanType,'' ) <> '';
                         END;
                 END;
         END;

GO
