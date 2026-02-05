SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomUpdatePlanCategories]
@IndigoClientId bigint,
@RegionCode varchar(2) = 'GB'
as

begin

declare @c table (Id bigint identity(1,1) primary key, PlanTypeName varchar(255), PlanCategoryName varchar(255))

--------------------------------------------------------------
-- this is the definitive list of which Plan Types belong 
-- to which Plan Category.
-- New ones can be added or existing ones updated as required.
-- Note that the spelling of the plan type and category is important!
-- use these queries to check the correct spelling:
-- Plan Types:
-- SELECT PlanTypeName FROM TRefPlanType ORDER BY PlanTypeName
-- Plan Categories:
-- SELECT PlanCategoryName FROM TPlanCategory GROUP BY PlanCategoryName
--------------------------------------------------------------

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Accident and Sickness Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Accident Sickness & Unemployment Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Alternatively Secured Pension Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Annuity (Non-Pension)','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Appropriate Personal Pension','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('AVC','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('BES','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Bridging Loan','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Capital Redemption Policy','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Cash Deposit','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Child Trust Fund','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('CIMP','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('CIMP & COMP','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Commercial Finance','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Commercial Property Purchase Scheme','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('COMP','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Conveyancing Servicing Plan','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('CPB','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Debenture','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Discretionary Managed Service','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Employee Benefit Trust','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Endowment','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Enterprise Investment Scheme','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Enterprise Investment Zone Trust','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Equity Holdings','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Equity Release','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Executive Pension Plan','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Film Partnership','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Final Salary Scheme','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Friendly Society Savings','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('FSAVC','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('FURBS','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Geared Investments','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('General Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Gift Inter Vivos','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group Accident and Sickness','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group Critical Illness','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group Death In Service','Pensions for Protection')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group Personal Pension','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group PHI','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group PMI','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Group Term','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Guaranteed Growth Bond','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Guaranteed Income Bond','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Hancock Annuity','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Insurance / Investment Bond','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Introducer','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Investment Trust','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('ISA','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Long Term Care','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Maximum Investment Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Money Purchase Contracted','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Mortgage','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('National Savings','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Non-Discretionary Managed Service','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('OEIC / Unit Trust','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore Bond','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore Deposit','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore OEIC / Fund','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore Pension','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore Regular Savings','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Offshore Savings Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Pension Annuity','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Pension Contribution Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Pension Fund Withdrawal','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Pension Term Assurance','Pensions for Protection')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Permanent Health Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Personal Equity Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Personal Loan','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Personal Pension Plan','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Phased Retirement','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Private Medical Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Property Partnership','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Redundancy Insurance','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Renewal','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Residential Property Development','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('s226 RAC','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('s32 Buyout Bond','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Savings Account','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('SIPP','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('SSAS','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Stakeholder Individual','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Stakeholder Pension Group','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Structured Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Term Protection','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('TESSA','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Third party mortgage','Loans')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Traded Endowment Plan','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Trustee Investment Plan','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Undetermined','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Unemployment Insurance','Protection and Life products')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Unregulated Collective Investments','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Unsecured Pension','Pensions for Income')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('UURBS','Pensions for savings')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Venture Capital Trust','Savings / investments')

INSERT INTO @c (PlanTypeName, PlanCategoryName) 
VALUES ('Whole Of Life','Protection and Life products')



--------------------------------------------------------------
-- end of the plan type list, don't modify anything below here
--------------------------------------------------------------



-- going to remove and then reinsert the CategoryPlanType records, so audit the delete first
INSERT INTO TCategoryPlanTypeAudit (PlanCategoryId, RefPlanTypeId, ConcurrencyId, CategoryPlanTypeId, StampAction, StampDateTime, StampUser)
SELECT  cpt.PlanCategoryId, RefPlanTypeId, cpt.ConcurrencyId, CategoryPlanTypeId, 'D', getdate(), '0'
FROM TCategoryPlanType cpt
JOIN TPlanCategory pc ON pc.PlanCategoryId = cpt.PlanCategoryId
WHERE pc.IndigoCLientId = @IndigoClientId

DELETE FROM cpt
FROM TCategoryPlanType cpt
JOIN TplanCategory pc ON pc.PlanCategoryId = cpt.PlanCategoryId
WHERE pc.IndigoClientId = @IndigoClientId

-- insert the new records
INSERT INTO TCategoryPlanType (PlanCategoryId, RefPlanTypeId, ConcurrencyId)
SELECT pc.PlanCategoryId, rpt.RefPlanTypeId, 1
FROM @c c
JOIN TPlanCategory pc ON c.PlanCategoryName = pc.PlanCategoryName
JOIN TRefPlanType rpt ON rpt.PlanTypeName = c.PlanTypeName
JOIN TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanTypeId = rpt.RefPlanTypeId
WHERE pc.IndigoClientId = @IndigoClientId AND rpt2pst.RegionCode = @RegionCode

-- audit the new inserts
INSERT INTO TCategoryPlanTypeAudit (PlanCategoryId, RefPlanTypeId, ConcurrencyId, CategoryPlanTypeId, StampAction, StampDateTime, StampUser)
SELECT  cpt.PlanCategoryId, RefPlanTypeId, cpt.ConcurrencyId, CategoryPlanTypeId, 'C', getdate(), '0'
FROM TCategoryPlanType cpt
JOIN TPlanCategory pc ON pc.PlanCategoryId = cpt.PlanCategoryId
WHERE pc.IndigoCLientId = @IndigoClientId

-- show the results
SELECT rpt.PlanTypeName, pc.PlanCategoryName 
FROM Tcategoryplantype cpt
join tplancategory pc on pc.plancategoryid = cpt.plancategoryid
join trefplantype rpt on rpt.refplantypeid = cpt.refplantypeid
where indigoclientid = @IndigoClientId
order by rpt.plantypename


end
GO
