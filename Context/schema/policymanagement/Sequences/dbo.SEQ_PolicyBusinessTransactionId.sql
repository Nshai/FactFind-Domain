--
-- Sequence used for Primary Key on PolicyManagement.dbo.TPolicyBusinessTransaction
--
CREATE SEQUENCE [dbo].SEQ_PolicyBusinessTransactionId AS BIGINT
START WITH 2000000000 -- seed to avoid collision with ids when migrating TPolicyBusinessFundTransaction
INCREMENT BY 1
CACHE 100
NO CYCLE