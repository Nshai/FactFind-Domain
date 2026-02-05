 
-----------------------------------------------------------------------------
-- Table: CRM.TRefRelationshipType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4ECE6A8A-4529-45B4-B17B-A4701E8E67E1'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRelationshipType ON; 
 
        INSERT INTO TRefRelationshipType([RefRelationshipTypeId], [RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible], [ConcurrencyId])
        SELECT 289, 'Property - Tenant - Former',0,0,0,0,1,NULL,3 UNION ALL 
        SELECT 291, 'Personal',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 294, 'Accountancy Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 295, 'Platform',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 303, 'Client by Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 304, 'Deputy',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 305, 'Provider contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 306, 'Independent Financial Advisers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 307, '(MWM) Relationship Manager',0,0,0,0,1,NULL,4 UNION ALL 
        SELECT 310, 'Police Force',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 309, 'IT Software',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 410, 'Professional Body',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 321, 'Investment & Wealth Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 322, 'Journalist & PR',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 323, 'Lawyer - Corporate & Commercial',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 324, 'Lawyer - Corporate Finance & Private Equity',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 325, 'Lawyer - Court of Protection',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 326, 'Lawyer - Employment',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 327, 'Lawyer - Family & Divorce',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 330, 'Lawyer - Litigation',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 331, 'Lawyer - Marketing',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 332, 'Lawyer - Tax',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 333, 'Lawyer - TMT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 334, 'Lawyer - Private Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 336, 'Lawyer - Trusts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 342, 'Product Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 343, 'Property & Real Estate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 347, 'Schools',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 350, 'Social Media',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 355, 'Traders & Brokers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 356, 'Travel & Hotels',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 360, 'Service Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 361, 'Property - Tenant - Prospective',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 363, 'Friend',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 366, 'Financial Advisor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 368, 'Internal Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 370, 'Actuary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 373, 'Director',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 375, 'Auditor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 376, 'Consultant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 377, 'Chief Executive Officer',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 380, 'Custodian',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 381, '1',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 384, 'Purdy Quinn',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 386, 'Group Scheme',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 387, 'Banker - Personal',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 389, 'Product Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 391, 'Platform Operator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 392, 'CBRE',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 394, 'Steven Hoare',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 398, 'AR',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 400, 'Lead Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 402, 'Sydney Mitchell',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 403, 'Opportura',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 409, 'DR',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 411, 'Designers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 413, 'Will Writers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 414, 'Corporate Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 415, 'Mortgage Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 416, 'Internet',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 417, 'Insurance Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 419, 'Doctor - GP',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 422, 'Internal Department',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 426, 'Surveyor - Valuation - Commercial',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 434, 'Deputyship',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 437, 'Consultancy Associate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 443, 'Mortgage Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 445, 'Bank / Building Society',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 447, 'Accounts Department',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 519, 'Client Administrator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 455, 'Risk Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 458, 'Spouse',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 459, 'NatWest',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 466, 'Tax Office',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 467, 'Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 469, 'Recommendation',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 471, 'SSAS Administrator ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 473, 'Discretionary Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 474, 'Property Maintenance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 479, 'Relative',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 485, 'Point of Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 486, 'Financial Controller',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 489, 'Attorney',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 490, 'Lenders',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 491, 'Bank Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 497, 'Support Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 502, 'Secondary Adviser ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 503, 'Corporate - Point of Contact',0,0,0,0,1,NULL,5 UNION ALL 
        SELECT 506, 'Branch Office',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 508, 'Compliance Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 513, 'Asset Transformation Report Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 515, 'Lead Trustee',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 524, 'Software Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 527, 'MEB Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 529, 'Advocates',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 530, 'Mortgage consultant ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 532, 'Finance Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 534, 'Trust',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 535, 'Life Assured',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 546, 'Specialist',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 548, 'Solicitor ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 549, 'Newsletter Email',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 560, 'Mortgage Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 561, 'Magazine ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 563, 'Lender/Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 565, 'Relation',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 568, 'Next of Kin',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 570, 'Payroll Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 580, 'Investment Manager/Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 595, 'Finance Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 598, 'Platform Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 601, 'New Business Private Wealth Clients',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 604, 'Regulator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 613, 'Media',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 623, 'Solicitor - commercial property',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 617, 'IFA ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 631, 'TPA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 632, 'ATR / Client Risk',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 634, 'Solictor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 645, 'Trust & Legal Advisor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 648, 'Payroll',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 672, 'Strategic Partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 676, 'Fund Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 702, 'Internal Investment Proposition',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 703, 'Payroll Support',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 711, 'Referral partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 715, 'Review Month',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 716, 'Unable to locate client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 720, 'SSAS Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 730, 'John Lamb - Broker ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 734, 'Accountants & Solicitors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 737, 'Computer Systems & E-Mail',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 739, 'Office Maintenance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 750, 'HMRC & Tax',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 742, 'Employment Agencies',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 283, 'Investment Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 284, 'Bank',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 285, 'Insurance Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 286, 'Estate Agent',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 287, 'POA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 288, 'Property - Tenant - Current',0,0,0,0,1,NULL,5 UNION ALL 
        SELECT 290, 'Client Referral',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 293, 'Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 346, 'Restaurants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 351, 'Speakers & Motivation',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 359, 'Wraps & Platforms',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 367, 'Financial Planner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 371, 'Insurance Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 432, 'Outsourced Technology Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 436, 'Insurance Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 463, 'Other Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 659, 'Grandchild',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 499, 'Individual Solicitor',0,0,0,0,1,NULL,3 UNION ALL 
        SELECT 511, 'Agency',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 518, 'Property Consultant ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 531, 'Tax',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 539, 'Sibling',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 545, 'Business Partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 553, 'Preferred Platform',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 572, 'Misc Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 594, 'Trust Company Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 602, 'Recruitment Consultants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 606, 'Westminster Wills Ltd',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 633, 'Solicitors ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 636, 'Child',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 637, 'Discretionary Fund Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 638, 'Landlord Unit 2 Higher Barn',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 640, 'Accountant - an individual',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 642, 'Trustee (Professional)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 643, 'General Insurers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 677, 'Internal Business Processes - Staff',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 680, 'Client (of Professional deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 682, 'Professional Deputy',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 704, 'Sister Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 706, 'Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 710, 'Press / Newspapers /Radio',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 724, 'Adviser - Mortgage',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 728, 'Risk Assured - Broker ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 743, 'IFA Tools & Research',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 745, 'Compliance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 754, 'Office Supplies',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 756, 'Catering, Restaurants & Entertainment ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 757, '360 Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 758, 'James Brearley & Sons',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 760, 'Doctors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 762, 'External IFA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 765, 'Broker Rep',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 779, 'Website',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 780, 'Deceased Partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 782, 'Personal Assistant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 785, 'Solicitor-NO AUTHORITY',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 788, 'Beneficiary/Remainderman',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 791, 'Lead Tech',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 794, 'TEST ACCOUNT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 795, 'My Main Man',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 804, 'Previous IFA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 799, '18 - 35',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 801, '55 - 75',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 806, 'New Acct Type',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 808, 'Other Professional Relationship',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 811, 'Attorney - LPA P&FA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 813, 'Beneficiary (of Trust)',0,1,1,1,0,NULL,1 UNION ALL 
        SELECT 814, 'Trust (for Beneficiary)',0,0,0,1,0,NULL,1 UNION ALL 
        SELECT 815, 'Trust (for Trustee)',0,0,0,1,0,NULL,1 UNION ALL 
        SELECT 816, 'Ward (of Financial Guardian)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 817, 'Ward (of Guardian)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 818, 'Ward (of Power of Attorney)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 819, 'Investment Fund Managers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 821, 'Person',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 822, 'Solicitor new',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 823, 'Accountancy Firms',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 824, 'Review',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 825, 'AMP Score',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 826, 'Signatory',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 831, 'Party of Interest',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 832, 'Referrer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 838, 'Corporate Introducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 1, 'Parent',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 2, 'Child',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 3, 'Employer',0,0,1,0,0,NULL,3 UNION ALL 
        SELECT 4, 'Employee',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 5, 'Grandparent',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 6, 'Grandchild',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 7, 'Partner',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 8, 'Business Partner',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 9, 'Spouse',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 10, 'Sibling',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 99, 'Network',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 218, 'Settlor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 142, 'Winterthur',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 143, 'DeFaqto Engage',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 233, 'Oil',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 243, 'Group Personal Pension',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 246, 'IFA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 253, 'Financial Limited',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 269, 'Beneficiary',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 266, 'Surveyor - Quantity',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 259, 'Recylcing Inks',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 258, 'Accountant - Personal',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 257, 'Insurance Broker - General',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 255, 'Trustee Company - Offshore',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 250, 'Professional Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 247, 'Existing Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 242, 'T4',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 234, 'Photocopier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 254, 'Trustee Company - Pension',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 210, 'Garraway',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 178, 'Friends & Relatives',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 272, 'FRP Golf Day',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 215, 'IT Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 209, 'Winchester',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 199, 'Rent',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 175, 'Professional Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 194, 'Trustees',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 157, 'Life Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 151, 'Aberdeen Global',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 141, 'Standard Life',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 140, 'Skandia',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 132, 'LV',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 129, 'Fidelity',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 128, 'Friends Provident',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 126, 'CoFunds',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 125, 'Clerical Medical',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 118, 'Sipp Centre',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 117, 'Intelliflo',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 260, 'Business',0,0,0,0,1,NULL,3 UNION ALL 
        SELECT 203, 'Mortgage Lender',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 193, 'Grandchildren',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 144, 'Zurich',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 111, 'CF Partners',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 108, 'BPL Solicitors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 279, 'Other',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 278, 'Employer (Partner)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 277, 'Employer (Member)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 276, 'Employer (Shareholder Non-Director)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 275, 'Employer (Shareholder Director)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 274, 'Employer (Key Person)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 273, 'Employer (Director)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 264, 'Engineer - Civil',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 251, 'LFFS',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 238, 'Camphill',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 212, 'Meet with Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 176, 'Recruitment',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 146, 'Finametrica',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 137, 'Scottish Widows',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 130, 'Invesco',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 127, 'Elevate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 84, '4N Member',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 79, 'Simply Biz',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 271, 'Local Authority',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 248, 'Miscellaneous',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 232, 'Printing',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 231, 'Stationary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 229, 'Lead Administrator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 226, 'Trigon Financial Solutions Ltd',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 219, 'Law Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 217, 'Owner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 214, 'Office Equipment Supplier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 201, 'LIfe Assurance Cos',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 196, 'Companies-Ins/Inv',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 177, 'Partner (Business)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 167, 'Anything you want',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 166, 'Power of Attorney',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 161, 'Other Professional',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 155, 'Trustee',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 82, 'Sales Consultant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 78, 'IT and systems contacts',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 150, 'Rensburg',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 282, 'Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 156, 'Mortgage Lenders',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 180, 'DFMs',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 189, 'Adviser Recruits',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 221, 'Private Bank',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 236, 'BT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 244, 'Child (not dependent)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 249, 'Administrator',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 261, 'Surveyor - Valuation - Domestic',0,0,0,0,1,NULL,3 UNION ALL 
        SELECT 11, 'In Law',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 12, 'Friend',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 13, 'Common Law',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 14, 'Step Child',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 15, 'Step Parent',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 16, 'Engaged',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 17, 'Ex-Partner',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 18, 'Ex-Spouse',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 19, 'Work Colleague',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 20, 'Ex-Employer',0,0,1,0,0,NULL,3 UNION ALL 
        SELECT 21, 'Ex-Employee',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 22, 'Trustee',0,1,1,1,0,NULL,3 UNION ALL 
        SELECT 23, 'Settlor',0,1,1,1,0,NULL,3 UNION ALL 
        SELECT 24, 'Beneficiary',1,1,1,1,0,NULL,3 UNION ALL 
        SELECT 25, 'Relative',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 26, 'Co-habiting',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 27, 'Separated',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 28, 'Parent Company',0,0,1,0,0,NULL,3 UNION ALL 
        SELECT 29, 'Subsidiary',0,0,1,0,0,NULL,3 UNION ALL 
        SELECT 32, 'Other',0,0,1,1,0,NULL,3 UNION ALL 
        SELECT 33, 'Other',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 40, 'Director',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 41, 'Key Person',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 42, 'Shareholder Director',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 43, 'Shareholder Non-Director',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 44, 'Partner',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 45, 'Primary Contact',0,0,1,1,0,NULL,3 UNION ALL 
        SELECT 46, 'Primary Contact',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 49, 'Attorney',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 50, 'Client',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 51, 'Civil Partner',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 52, 'Receiver',0,1,0,0,0,NULL,2 UNION ALL 
        SELECT 53, 'Widow',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 54, 'Widower',0,1,0,0,0,NULL,3 UNION ALL 
        SELECT 55, 'Trustee',0,0,1,0,0,NULL,2 UNION ALL 
        SELECT 56, 'Trustee',0,1,0,0,0,NULL,2 UNION ALL 
        SELECT 57, 'Spouse (Deceased)',0,1,0,0,0,NULL,2 UNION ALL 
        SELECT 58, 'Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 59, 'Supplier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 60, 'Press',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 61, 'Utility',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 62, 'Telephone',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 63, 'Estate Agents',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 64, 'Friends',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 65, 'Events Co-ordinator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 66, 'Partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 67, 'Lead',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 68, 'Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 69, '3rd Party Introducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 70, 'Email',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 71, 'Accountants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 72, 'Solicitors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 73, 'Broker Consultant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 75, 'Utilities',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 104, 'Non-Affiliate Introducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 77, 'Introducers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 80, 'Accountant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 81, 'Broker Development Consultant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 83, 'Quotes Team',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 96, 'Introducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 87, 'Solicitor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 97, 'HLP',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 100, 'Griffith Clarke',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 91, 'AGL Tax Solutions',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 92, 'AGL Consultants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 93, 'Group Account Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 101, 'Corporate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 102, 'Network Member',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 103, 'HFM Columbus',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 105, 'Surveyor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 106, 'Lender',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 107, 'Insurer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 109, 'Barnetts Solicitors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 110, 'MRS - Charity',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 112, 'Executor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 113, 'Provider Individual',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 114, 'Locum',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 115, 'Business Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 152, 'Financial Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 119, 'Ascentric',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 120, 'Transact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 121, 'Aegon',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 122, 'Aviva',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 123, 'Axa',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 124, 'Canada Life',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 133, 'Lombard',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 134, 'Prudential',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 135, 'Scottish Equitable',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 136, 'Scottish Life',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 138, 'Scottish Mutual',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 139, 'Selestia (Skandia Investment Solutions)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 145, 'Exchange Web',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 147, 'IT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 148, 'L&G',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 149, 'Axa Winterthur',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 153, 'Cherry',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 158, 'Which',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 159, 'Dean Wilson LLP',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 160, 'Family Member',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 162, 'Doctor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 281, 'doctors surgery ',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 280, 'Finance Director',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 270, 'Terms of Business',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 345, 'Remuneration Consultants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 265, 'Engineer - Structural',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 263, 'Architect',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 262, 'Surveyor - Environmental',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 256, 'Trustee Company - Onshore (Life & Investments)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 252, 'Lubbock Fine',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 240, 'Testaccounttype_Mallika',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 239, 'Company Representative',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 237, 'Bankhall',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 235, 'Franking Machine',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 230, 'I.T. Technician',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 228, 'Lead Administartor ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 227, 'Trigon Support Services Ltd',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 225, 'Trigon Corporate Solutions Ltd ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 224, 'Charity',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 223, 'Mortgage Intermediary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 222, 'Advocate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 220, 'Professional Trustee',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 216, 'Business Coach',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 213, 'Employee',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 211, 'General Insurance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 208, 'Darwin',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 207, 'Staff',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 206, 'SIPP Administrator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 205, 'GP',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 204, 'Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 202, 'Others',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 200, 'Fund Managers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 198, 'IntelliFo Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 197, 'BDM',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 195, 'Parent',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 192, 'Children',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 191, 'IntelliFlo Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 190, 'Mortgage Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 188, 'RI Firms',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 187, 'Hospitality',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 186, 'Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 185, 'Will Writer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 184, 'Care Home',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 183, 'Stockbroker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 182, 'Chartered Surveyor ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 181, 'Commercial Mortgage Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 179, 'School',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 173, 'Banks',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 172, 'Joint Mortgage',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 171, 'Employer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 170, 'Professional Introducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 169, 'NoNodrog01',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 168, 'Beneficiary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 165, 'Member',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 164, 'Testator',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 163, 'Executor',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 353, 'Students & Interns',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 362, 'Accountant - Corporate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 364, 'Tax Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 383, '3',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 433, 'Servicing Administrator',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 460, 'Auditors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 495, 'SIFA',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 536, 'Finance MRM Billing',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 566, 'Surveyors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 576, 'Counterparty',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 585, 'RISK V REWARD ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 619, 'Stationary Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 639, 'test',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 655, 'Lender - Secured Loans',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 656, 'Lender - Mortgage Intermediary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 660, 'Housing Association',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 665, 'New Business',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 667, 'My Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 712, 'Landlord',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 721, 'SSAS - Point of Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 751, 'Marketing, Website & Exhibitions',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 755, 'Insurance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 776, 'Bankers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 800, '35 - 55',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 836, 'Corporate - Death In Service',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 292, 'Authorities',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 329, 'Lawyer - Immigration',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 341, 'Offshore Centres',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 344, 'Prospects',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 348, 'Secretarial & Lifestyle',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 349, 'Security',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 352, 'Sport',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 372, 'Credit Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 374, 'Chairman',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 379, 'General Counsel',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 396, 'Trust - Beneficiary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 404, 'Brendan Fleming',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 405, 'Proactive Independent Mortgage Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 407, 'Paa',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 420, 'Auto Enrolment',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 462, 'Invoice Address',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 481, 'Conveyancer',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 484, 'Intoducer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 544, 'Accountant ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 600, 'Pension Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 625, 'Solicitor - Trusts & Estate (TEP)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 628, 'Solicitor / Property Conveyancer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 675, 'Lender - Development',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 700, 'Parents',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 709, 'GI Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 736, 'Mobile Phones',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 783, 'Shareholder',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 719, 'Solicitor - Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 767, 'Agency Numbers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 789, 'Policy Owner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 311, 'RPOAS',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 313, 'Ward',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 314, 'Financial Guardian',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 315, 'Guardian',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 316, 'Power of Attorney',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 317, 'Ward',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 318, 'Financial Guardian',0,0,0,1,0,NULL,1 UNION ALL 
        SELECT 319, 'Guardian',0,0,0,1,0,NULL,1 UNION ALL 
        SELECT 320, 'Power of Attorney',0,0,0,1,0,NULL,1 UNION ALL 
        SELECT 354, 'Technology & IT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 365, 'Compliance Diary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 369, 'Other',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 412, 'Power of Attorneys',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 438, 'Birthday Cards',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 452, 'DFM',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 478, 'HR Consultancy',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 488, 'Complainant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 492, 'Migration Agent',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 509, 'Internal Division',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 514, 'Financial Planning Report writers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 537, 'Finance MEB Billing',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 541, 'Individual',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 554, 'Employee Benefits Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 582, 'Wealth Advisers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 626, 'Trustee - Professional Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 630, 'Investment Manager ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 714, 'Payroll Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 778, 'Discretionary Fund Managers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 803, '75 +',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 812, 'Secondary Owner - example of name',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 829, 'Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 837, 'Corporate - Group CIC',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 328, 'Lawyer - Financial Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 335, 'Lawyer - Property & Real Estate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 337, 'Lloyds & Insurance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 338, 'Management Consultant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 339, 'Market Research',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 340, 'Medical',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 397, 'Utility Company',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 425, 'Property - Co-Owner - Connected',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 429, 'Outsourced Support Team',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 440, 'Builders',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 465, 'Residential Address',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 501, 'Trust',1,0,0,1,0,NULL,2 UNION ALL 
        SELECT 505, 'Designer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 523, 'Not our client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 550, 'Group Scheme Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 574, 'Consultancy Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 575, 'Property',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 599, 'Protection Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 621, 'Trustee (individual)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 707, 'Networking Groups',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 729, 'VIE International - Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 809, 'SFIA DFM Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 357, 'Trusts & Trustees',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 358, 'Wealth Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 406, 'Telesales',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 441, 'Banking',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 526, 'Probate Solicitors',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 593, 'Will / LPA Company Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 608, 'Trustee',1,1,1,1,0,NULL,1 UNION ALL 
        SELECT 609, 'Other',1,1,1,1,0,NULL,1 UNION ALL 
        SELECT 644, 'Misc.',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 658, 'Valuers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 664, 'Tax Information',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 673, 'Investment Platform',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 723, 'Fee Earner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 735, 'Training & Learning',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 777, 'Other Introducers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 786, 'Solicitor-Authority Given',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 833, 'Retail',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 834, 'Retail Complex',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 378, 'Chief Financial Officer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 382, '2',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 385, 'Anything you like',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 388, 'Banker - Corporate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 390, 'Bhaskar_AT',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 393, 'POA - Power of Attorney ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 395, 'Trust - Individual Trustee',0,0,0,0,1,NULL,2 UNION ALL 
        SELECT 399, 'Company Supplier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 401, 'General Practitioner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 408, 'MAngels',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 520, 'Court of Protection',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 421, 'Private Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 424, 'Property - Co-Owner - Unconnected',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 427, 'Conveyancers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 435, 'Financial Guardian',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 431, 'Marketing & Development services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 439, 'Tax Return Service',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 442, 'Insurance Brokers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 444, 'DLA Partner',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 446, 'Property Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 448, 'Marketing Department',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 449, 'Agent',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 454, 'Professional Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 456, 'Newsletter by Email',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 457, 'General Insurance Brokers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 461, 'General Insurance Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 464, 'Registered Address',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 468, 'Provider Contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 470, 'Mortgage Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 472, 'Secretary',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 477, 'Beneficiaries',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 482, 'Lawyer',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 483, 'Insurer contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 487, 'Training',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 494, 'HMRC',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 496, 'Advisory Network',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 498, 'Marketing and Web Development',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 500, 'Solicitors Practice',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 504, 'Marketing',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 507, 'HR Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 516, 'Partner - Business',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 522, 'New Account12',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 525, 'Compliance Support',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 528, 'Trust Relationships',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 533, 'MFP Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 538, 'Tax Lawyers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 547, 'MFP Supplier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 603, 'Tenants',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 555, 'Simpkins Edwards',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 557, 'Tax Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 558, 'Employer Pension (For Whom We Don''t Act)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 562, 'Mortgage Advisor',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 564, 'HR',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 567, 'Mortgage Related',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 569, 'HR Director',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 571, 'Review Months',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 584, 'Payroll Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 592, 'Will Company Provider',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 590, 'Killik Investment Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 605, 'Suppliers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 607, 'Provider - Investments - Pensions - Life Cover ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 610, 'Pensioneer Trustee',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 612, 'Associate',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 616, 'IF-Project & Task Management',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 618, 'Technical Help',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 622, 'Solicitor - generalist',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 624, 'Professional Legal Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 627, 'Accountancy Professional Firm',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 629, 'Taxi',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 635, 'Corporate Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 641, 'Financial Adviser (individual)',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 647, 'Unbiased paid lead',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 649, 'Postage',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 650, 'Financial Services',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 657, 'Lender - House Insurance',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 681, 'Client (of Lay deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 661, 'FH Admin',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 662, 'Annual Review',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 663, 'Adhoc Information Request - Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 666, 'Wealth Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 674, 'Phil''s contacts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 683, 'Lay Deputy',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 684, 'Client (of Professional deputy)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 685, 'Client (of Lay deputy)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 686, 'Professional Deputy',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 687, 'Lay Deputy',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 688, 'Client (of Professional deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 689, 'Client (of Lay deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 690, 'Professional Deputy',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 691, 'Lay Deputy',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 692, 'Client (of Professional deputy)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 693, 'Client (of Lay deputy)',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 694, 'Professional Deputy',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 695, 'Lay Deputy',0,0,1,0,0,NULL,1 UNION ALL 
        SELECT 696, 'Client (of Professional deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 697, 'Client (of Lay deputy)',0,1,0,0,0,NULL,1 UNION ALL 
        SELECT 698, 'Professional Deputy',0,1,0,1,0,NULL,1 UNION ALL 
        SELECT 699, 'Lay Deputy',0,1,0,1,0,NULL,1 UNION ALL 
        SELECT 701, 'Commercial Client',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 705, 'Community',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 708, 'Protection Providers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 713, 'Carehome',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 722, 'Point of Contact ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 725, 'Adviser - Financial',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 731, 'Solicitor - Personal',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 732, 'Employer ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 738, 'Building Societies',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 740, 'General Suppliers',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 744, 'Professional Bodies',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 746, 'Software',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 747, 'Regulators & Authorities',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 749, 'Professional Publications & Websites',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 753, 'Utilities ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 759, 'Stock Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 761, 'Company Contact',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 770, 'Business Development Manager',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 771, 'IR - Supplier',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 772, 'IR - Utility',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 773, 'IR - IT & Telecoms',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 775, 'Attorney ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 781, 'Professional Connection',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 787, 'Life Tenant',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 748, 'Alarms, Fire, Health & Safety',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 784, 'Stock-Broker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 764, 'External IFA Accounts',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 790, 'Company ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 792, 'Regulators',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 793, 'Third Party',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 796, 'The Man',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 798, '0-18',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 805, 'Private Banker',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 807, 'Independent Financial Adviser',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 810, 'Attorney - LPA H&W',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 827, 'Fake introducers ',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 830, 'Professional Relationships',0,0,0,0,1,NULL,1 UNION ALL 
        SELECT 835, 'Corporate Adviser Sharing',0,0,0,0,1,NULL,1 
 
        SET IDENTITY_INSERT TRefRelationshipType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4ECE6A8A-4529-45B4-B17B-A4701E8E67E1', 
         'Initial load (735 total rows, file 1 of 1) for table TRefRelationshipType',
         null, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
	RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, '', @ErrorLine, @ErrorMessage);
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 735
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
