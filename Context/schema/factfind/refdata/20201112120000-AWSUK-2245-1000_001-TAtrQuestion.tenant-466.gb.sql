 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrQuestion
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4B9A9AE1-F846-40AB-8786-4106D705CAD8'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrQuestion ON; 
 
        INSERT INTO TAtrQuestion([AtrQuestionId], [Description], [Ordinal], [Investment], [Retirement], [Active], [AtrTemplateGuid], [IndigoClientId], [Guid], [ConcurrencyId])
        SELECT 22, 'In order to see potential gain, what amount of risk are you currently prepared to take with your financial investments?',1,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'779605F5-A93C-4B61-AD42-4E1477FFCD21',1 UNION ALL 
        SELECT 23, 'Compared to others, what amount of risk have you taken with your past financial decisions?',2,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'A971DCB3-3ADA-4384-B854-C32D1BF7F60E',1 UNION ALL 
        SELECT 24, 'I want my investment money to be safe even if it means lower returns.',3,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'6FE53D44-A938-4CF0-86CC-F8CECD60C166',1 UNION ALL 
        SELECT 25, 'Imagine that six months after making an investment the financial markets start to perform badly.  In line with this, your own investment goes down by 20%.  What would your reaction be?',4,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'8637AAB7-0F64-48EB-B7AB-4A5C8B7AEE6A',1 UNION ALL 
        SELECT 26, 'How would a close friend describe your attitude to taking financial risks?',5,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'CB5D7118-AA65-4751-BA48-573AB4EE57D9',1 UNION ALL 
        SELECT 27, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',6,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'AA3302CD-2FB0-494A-AF72-D5AFE3F82CAE',1 UNION ALL 
        SELECT 28, 'I would go for the best possible return even if there was risk involved.',7,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'297902D8-6131-4EE9-93E5-F8E11D475A2C',1 UNION ALL 
        SELECT 29, 'Imagine that you have some money to invest and a choice of two investment products, what annual average return and what annual risk of loss would you be prepared to accept?',8,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'753EB54F-C8FB-4EAD-8C52-B2675B57FCD2',2 UNION ALL 
        SELECT 30, 'An investment that has the potential to make a lot of money will usually also have a greater risk of losing money.  How much of the money that you have to invest would you be willing to place in an investment with potential high returns but with an equal element of risk?',9,1,1,1,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',466,'CF8B8A86-DD3A-4C7C-8F80-2F333C3E5107',1 UNION ALL 
        SELECT 31, 'In order to see potential gain, what amount of risk are you currently prepared to take with your financial investments?',1,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'6538BB47-C1F1-4CEE-996F-0C3F142913B2',1 UNION ALL 
        SELECT 32, 'Compared to others, what amount of risk have you taken with your past financial decisions?',2,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'CE596D35-1862-434F-AF60-F68EDC51667B',1 UNION ALL 
        SELECT 33, 'I want my investment money to be safe even if it means lower returns.',3,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'28C549C9-FD73-4F0B-B0E8-2E707056C9FD',1 UNION ALL 
        SELECT 34, 'Imagine that six months after making an investment the financial markets start to perform badly.  In line with this, your own investment goes down by 20%.  What would your reaction be?',4,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'4146145E-DC1B-4CEE-BCCC-021D4D834E5B',1 UNION ALL 
        SELECT 35, 'How would a close friend describe your attitude to taking financial risks?',5,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'4E013004-0742-4EB8-B8BA-B99A3AC16B26',1 UNION ALL 
        SELECT 36, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',6,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'C8ACC61C-17C2-4711-98DA-049E688417C8',1 UNION ALL 
        SELECT 37, 'I would go for the best possible return even if there was risk involved.',7,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'598243E7-4084-4941-9E4A-C9CBA4E1B812',1 UNION ALL 
        SELECT 38, 'Imagine that you have some money to invest and a choice of two investment products, what annual average return and what annual risk of loss would you be prepared to accept?',8,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'368471F1-FE2D-495E-A93B-46DC4FAB44A5',2 UNION ALL 
        SELECT 39, 'An investment that has the potential to make a lot of money will usually also have a greater risk of losing money.  How much of the money that you have to invest would you be willing to place in an investment with potential high returns but with an equal element of risk?',9,1,1,1,'CF1FD26B-875D-4F86-9908-405BFAC21C84',466,'D1862167-4B14-4776-B0C2-2BD122687B6B',1 UNION ALL 
        SELECT 40, 'I enjoy exploring investment opportunities for my money',1,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'E45D4F86-9A99-44BC-B468-5ABB7EA05CC0',1 UNION ALL 
        SELECT 41, 'I would go for the best possible return even if there was risk involved',2,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'83574F82-E123-417B-A6A4-A3735D96BC3A',1 UNION ALL 
        SELECT 42, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'8C87D269-66AE-4F48-A06F-F7DB0339353E',1 UNION ALL 
        SELECT 43, 'If I get bad financial news I will tend to worry about it more than most people would in the same situation',4,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'82C47A0F-0A0A-4392-A797-30EA1E51C554',1 UNION ALL 
        SELECT 44, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'D461D2BF-F98E-4F33-9624-FD5FCAC62914',1 UNION ALL 
        SELECT 45, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'65DBBF40-14DC-49BF-B218-92E016B2F75B',1 UNION ALL 
        SELECT 46, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this',7,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'122D54E5-4474-4D6B-98F2-25C19EA21273',1 UNION ALL 
        SELECT 47, 'An investment that has the potential to make a lot of money will usually also have a greater risk of losing money.  How much of the money that you have to invest would you be willing to place in an investment with potential high returns but with an equal element of risk?',8,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'BA66BD38-89B5-4F43-B1D4-0E2F7630B7CB',1 UNION ALL 
        SELECT 48, 'How would a close friend describe your attitude to taking financial risks?',9,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'A17248D8-159C-4BDB-B5B6-59DA8C7E1FC7',1 UNION ALL 
        SELECT 49, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',10,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'2BB0772C-31E9-440C-815D-3A8F58438EB3',1 UNION ALL 
        SELECT 50, 'Imagine that you have some money to invest and a choice of two investment products, what annual average return and what annual risk of loss would you be prepared to accept?',11,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'C8B6B8B8-7F00-4FFD-A6C4-07450728E508',2 UNION ALL 
        SELECT 51, 'I would prefer small certain gains to large uncertain ones.',12,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'919CB03C-CE22-47EA-A057-69F4A9482399',1 UNION ALL 
        SELECT 52, 'When considering a major financial decision which statement MOST describes the way you think about the possible losses or the possible gains?',13,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'FE988997-3F79-40E9-8592-B8D51F608777',1 UNION ALL 
        SELECT 53, 'I want my investment money to be safe even if it means lower returns.',14,1,1,1,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',466,'9A5BF327-CDD1-426D-8D88-B895F18BA357',1 UNION ALL 
        SELECT 54, 'I enjoy exploring investment opportunities for my money',1,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'066EBBA0-553A-4F9F-A130-75702A54EEF7',1 UNION ALL 
        SELECT 55, 'I would go for the best possible return even if there was risk involved',2,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'9EB30944-624F-4AEF-A4AD-D49E0C22E90C',1 UNION ALL 
        SELECT 56, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'CB4907BB-8AE8-4A51-BDF1-722F122FCD11',1 UNION ALL 
        SELECT 57, 'If I get bad financial news I will tend to worry about it more than most people would in the same situation',4,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'E1CDC712-4E94-4AC2-A81A-62376F9A2F30',1 UNION ALL 
        SELECT 58, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'D02586A4-E5EC-4572-84A4-0E3F776DF921',1 UNION ALL 
        SELECT 59, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'4CE37D25-D85B-4B74-9C53-77962239C6C9',1 UNION ALL 
        SELECT 60, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this',7,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'89D83AE4-9790-4745-A74E-D4E92C13FE59',1 UNION ALL 
        SELECT 61, 'An investment that has the potential to make a lot of money will usually also have a greater risk of losing money.  How much of the money that you have to invest would you be willing to place in an investment with potential high returns but with an equal element of risk?',8,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'91539B38-48F0-431B-95D4-155B9BA5F20C',1 UNION ALL 
        SELECT 62, 'How would a close friend describe your attitude to taking financial risks?',9,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'674EF066-30DB-434A-A9B3-A117DFA7E78A',1 UNION ALL 
        SELECT 63, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',10,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'853AEF0E-662D-4364-A0AC-6BC2BC98D023',1 UNION ALL 
        SELECT 64, 'Imagine that you have some money to invest and a choice of two investment products, what annual average return and what annual risk of loss would you be prepared to accept?',11,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'01F0BB42-85F0-4828-B0CE-8FB4C5F5C7DC',2 UNION ALL 
        SELECT 65, 'I would prefer small certain gains to large uncertain ones.',12,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'E68DB04E-1D65-43A0-97ED-78C26731AF4D',1 UNION ALL 
        SELECT 66, 'When considering a major financial decision which statement MOST describes the way you think about the possible losses or the possible gains?',13,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'62BB14F7-34AE-4F2A-A0CD-A10E10ED2545',1 UNION ALL 
        SELECT 67, 'I want my investment money to be safe even if it means lower returns.',14,1,1,1,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',466,'CFD891B9-E619-4EC9-A73F-9C8BDDA0138C',1 UNION ALL 
        SELECT 9296, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'CF6924B4-7733-4E1E-A2E1-C50D05F9FCC0',1 UNION ALL 
        SELECT 15192, 'I would prefer small certain gains to large uncertain ones',13,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'C05EFF37-EF2F-4D0A-850F-A73000A3FC29',2 UNION ALL 
        SELECT 15194, 'I want my investment money to be safe even if it means lower returns.',15,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'58A1499B-129A-4D22-82B9-A73000A4F738',2 UNION ALL 
        SELECT 9297, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'026F3C20-4922-4187-A6E6-C498698B7345',1 UNION ALL 
        SELECT 9298, 'How would a close friend describe your attitude to taking financial risks?',12,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'DF9E19D1-BC93-4242-941D-8B412467AE28',1 UNION ALL 
        SELECT 9299, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'4E17B01A-DA61-4EA6-874B-4F290913E337',1 UNION ALL 
        SELECT 9283, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'378B6248-2942-49FD-BADE-49E9331650F0',1 UNION ALL 
        SELECT 9284, 'Compared to others, what amount of risk have you taken with your past financial decisions?',4,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'3894CEB7-EA83-48DF-A27E-5445CF91B1EF',1 UNION ALL 
        SELECT 12233, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'C22010FC-0B52-4801-90DD-3FBF3DAFA016',1 UNION ALL 
        SELECT 12234, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'D45DF428-4E00-4837-A386-E7BC25F32F2F',1 UNION ALL 
        SELECT 12235, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'45A5A4A0-0D52-4CC7-8C40-C610714BA033',1 UNION ALL 
        SELECT 12236, 'What amount of risk do you feel you have taken with your past financial decisions?',4,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'33A84E29-EE33-4AEB-8066-88982AAE609E',1 UNION ALL 
        SELECT 12237, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall',5,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'DEFA6D4E-C354-43FD-A59B-6293F9DD3BA5',1 UNION ALL 
        SELECT 12238, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this',6,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'00825448-E622-4529-9B4F-301DD49ABCC2',1 UNION ALL 
        SELECT 12239, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',7,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'D1CC65E7-04D5-43CB-A8C9-31D23A3604C8',1 UNION ALL 
        SELECT 12240, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',8,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'1A16644A-A986-4F3F-91FF-98CBB1B0D5B9',1 UNION ALL 
        SELECT 12241, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel:',9,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'371CB43B-D466-42F7-9A75-A6A6CC6FEED5',1 UNION ALL 
        SELECT 12242, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose? ',10,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'2A474ACF-5785-42B4-BA14-928D15E8B0CF',1 UNION ALL 
        SELECT 12243, 'I would prefer small certain gains to large uncertain ones',11,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'60FA5127-29A4-48C5-8460-2AD0DD9EC575',1 UNION ALL 
        SELECT 12244, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',12,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'CDEC31D2-4446-4FC8-85DF-ABF042770A5E',1 UNION ALL 
        SELECT 12245, 'I want my investment money to be safe even if it means lower returns',13,1,1,1,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',466,'5AC70B7D-833A-4046-9D34-477FA3D76F25',1 UNION ALL 
        SELECT 12246, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'9E730017-2653-4FEA-BF9D-C2971497122E',1 UNION ALL 
        SELECT 12247, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'5EF2E558-2789-47D1-87A9-B43FF59AC5E1',1 UNION ALL 
        SELECT 12248, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'AABA8EA7-4BE2-4D39-A9DC-77889DC07B63',1 UNION ALL 
        SELECT 12249, 'What amount of risk do you feel you have taken with your past financial decisions?',4,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'9E4FF44B-1CA4-49E9-8CF2-0514FD9F342F',1 UNION ALL 
        SELECT 12250, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall',5,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'D47D233E-B7E3-42ED-BB76-59B8E492D949',1 UNION ALL 
        SELECT 12251, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this',6,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'B6E27D7B-B453-4C0F-96EB-729911C82B42',1 UNION ALL 
        SELECT 12252, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',7,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'7BA2E352-18BF-4139-92E5-220FF41E9F75',1 UNION ALL 
        SELECT 12253, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',8,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'55409C54-6248-4045-A06F-EAF0CA7DF04E',1 UNION ALL 
        SELECT 12254, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel:',9,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'95B2C297-797D-4E33-B42D-37B810BFF803',1 UNION ALL 
        SELECT 12255, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose? ',10,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'A3022DC3-C605-42DF-985E-BBCBA87C772A',1 UNION ALL 
        SELECT 12256, 'I would prefer small certain gains to large uncertain ones',11,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'EA6D888C-0382-4D70-A0BE-648C4704B177',1 UNION ALL 
        SELECT 12257, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',12,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'664545CB-898A-4AF6-B1D3-B585C60F61C7',1 UNION ALL 
        SELECT 12258, 'I want my investment money to be safe even if it means lower returns',13,1,1,1,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',466,'BD0E4ECA-AC31-4187-9817-3CA4F49BD00C',1 UNION ALL 
        SELECT 12259, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'E9D31A15-9C4E-4C6B-ABE5-05EDEF8FFB41',1 UNION ALL 
        SELECT 12260, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'C98F9251-0D96-45C8-A2BB-387EEF814BFD',1 UNION ALL 
        SELECT 12261, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'3D468595-A710-4E6D-BE5E-23246D82816B',1 UNION ALL 
        SELECT 12262, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'6B40D95E-9B4C-40D8-B42C-0FBEB49A0FCF',1 UNION ALL 
        SELECT 12263, 'What amount of risk do you feel you have taken with your past financial decisions? ',5,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'4B1198C2-7372-4E15-A4EA-90FF4D5FC539',1 UNION ALL 
        SELECT 12264, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'869304CB-C45C-4E46-B522-F86D962EB9DC',1 UNION ALL 
        SELECT 12265, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'9E750FCA-0EB8-44B3-A80E-BA11AB029E89',1 UNION ALL 
        SELECT 12266, 'Imagine that six months after making an investment the financial markets start to perform badly.  In line with this, your own investment goes down by a significant amount.  What would your reaction be?',8,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'E828AAE6-074C-45C8-8014-151EC31A90B9',1 UNION ALL 
        SELECT 12267, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'E1BFC6D5-E5BA-4960-8FE8-17411D3E8A36',1 UNION ALL 
        SELECT 12268, 'I usually feel confident where money is concerned.',10,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'279B94BB-A591-40DC-BE56-716D30258A18',1 UNION ALL 
        SELECT 12269, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',11,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'6FA68984-569C-428B-8BA3-C4A447EA1E4F',1 UNION ALL 
        SELECT 12270, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',12,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'A9AF16F0-8069-401B-9973-87E44910A431',1 UNION ALL 
        SELECT 12271, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'E4F331AC-BB45-420E-845B-2520A5901EFD',1 UNION ALL 
        SELECT 12272, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel',14,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'541FB361-B687-40EE-B581-49F19738B6E3',1 UNION ALL 
        SELECT 12273, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose? ',15,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'275B79EF-98F1-4D3A-954F-37522A9C3D61',1 UNION ALL 
        SELECT 12274, 'I would prefer small certain gains to large uncertain ones',16,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'5B2DF928-ECBE-4343-9F27-DF29B1F2CA69',1 UNION ALL 
        SELECT 12275, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'1758E5CB-F9B6-47E6-B3D2-93318399FFAD',1 UNION ALL 
        SELECT 12276, 'I want my investment money to be safe even if it means lower returns',18,1,1,1,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',466,'B7BEAB74-F91B-4A0A-B70E-90C6498C996F',1 UNION ALL 
        SELECT 9087, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'B8F958EF-A314-4CE3-B495-EF6B018B9FEC',1 UNION ALL 
        SELECT 9088, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'495F2856-5EB3-47CC-8DB8-B0B2E8BA9FCF',1 UNION ALL 
        SELECT 9089, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'FB5575D2-2E45-41B4-980E-4D1A5B563F03',1 UNION ALL 
        SELECT 9090, 'I usually feel confident where money is concerned.',10,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'CE602CD1-392E-4099-AAAE-A96242089721',1 UNION ALL 
        SELECT 9091, 'I want my investment money to be safe even if it means lower returns.',18,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'686DE998-38B4-4EC4-A40F-9AD8CCC7D9F5',1 UNION ALL 
        SELECT 9092, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'DD246C7D-FC42-49E4-B645-08B2A71C2F6A',1 UNION ALL 
        SELECT 9093, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'49024F0C-EE49-4FEB-B829-BF47C272F295',1 UNION ALL 
        SELECT 9094, 'I would prefer small certain gains to large uncertain ones.',16,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'A4DF49AC-576A-4882-A6BF-9CFDE966CF73',1 UNION ALL 
        SELECT 9095, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'109E16E8-F875-4E5D-8B31-B55959484389',1 UNION ALL 
        SELECT 9096, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',11,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'E36ADB20-FA58-44DE-BD37-2DB65E756C7C',1 UNION ALL 
        SELECT 9097, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',14,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'68B37A1B-83B9-4F4B-9DCD-0EE4AF0B1525',1 UNION ALL 
        SELECT 9098, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'800F2788-6AAE-4E37-A86B-C035F6C2F83A',1 UNION ALL 
        SELECT 9099, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',8,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'A6510FEB-BCA4-4440-AB19-A4DEAF161E58',1 UNION ALL 
        SELECT 9100, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',15,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'71F334F1-DCE1-4256-BCE1-E9B3C59B4ABC',1 UNION ALL 
        SELECT 9101, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'DBDBA692-8B4D-4C95-A566-4B7DBB9D9138',1 UNION ALL 
        SELECT 9102, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'1C46C5BE-AFA0-4F4C-B4CC-8990A96199CF',1 UNION ALL 
        SELECT 9103, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'45C43EBF-98DC-4C10-AAA2-795743265715',1 UNION ALL 
        SELECT 9104, 'Which of these statements best describes your own attitude to your finances?',12,1,1,1,'FD599F18-DD7E-41FD-9798-B520520D2B61',466,'70D8AB08-2DFD-4022-BD2B-30F5B5D9E9ED',1 UNION ALL 
        SELECT 9105, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'84D6E6A7-4E07-48A0-9E9F-C533B3E0A573',1 UNION ALL 
        SELECT 9106, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'F4F2FC69-C03E-4B04-A868-06D37C74354A',1 UNION ALL 
        SELECT 9107, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'073729BA-849E-463E-BE4A-6745B84E5DEA',1 UNION ALL 
        SELECT 9108, 'I usually feel confident where money is concerned.',10,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'AA9E7148-D246-4F92-AAFC-CEDD03CC90B8',1 UNION ALL 
        SELECT 9109, 'I want my investment money to be safe even if it means lower returns.',18,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'2E2769FC-BAA3-43A2-8CCC-E3A378295FCC',1 UNION ALL 
        SELECT 9110, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'25DFA992-D870-47BC-A2BC-21CBEFD4ED6F',1 UNION ALL 
        SELECT 9111, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'3D1ACEB3-4C7B-4F09-A3A3-4735AA294C03',1 UNION ALL 
        SELECT 9112, 'I would prefer small certain gains to large uncertain ones.',16,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'A8887269-1A71-45B1-AC7B-FF1CE9CCDB78',1 UNION ALL 
        SELECT 9113, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'F6FCC6AB-9FAE-4D07-AA87-0274EDFF1F57',1 UNION ALL 
        SELECT 9114, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',11,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'ACB5004D-7D02-4D7A-B935-73B75A82B531',1 UNION ALL 
        SELECT 9115, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',14,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'CD8A517D-6ABD-44C3-9232-D55AE81F09CD',1 UNION ALL 
        SELECT 9116, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'CFFE2051-F030-472B-BA13-A1F41453FD68',1 UNION ALL 
        SELECT 9117, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',8,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'9F43B984-AD9E-4637-9D55-ED3F0B82600A',1 UNION ALL 
        SELECT 9118, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',15,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'E7CAB48F-25CD-4447-8378-4DD4BB50F2B2',1 UNION ALL 
        SELECT 9119, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'70B751C6-EA17-4E5F-8EF2-F907431BA367',1 UNION ALL 
        SELECT 9120, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'EFCD5F52-6C3F-43C8-8B26-84FBB8CC9EF6',1 UNION ALL 
        SELECT 9121, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'602B4721-E934-4489-9419-CD16C7358922',1 UNION ALL 
        SELECT 9122, 'Which of these statements best describes your own attitude to your finances?',12,1,1,1,'47D79A15-68DD-46DE-97EA-79E327EB6636',466,'168F475B-D9F9-4497-AA9B-3EB7184F450E',1 UNION ALL 
        SELECT 9294, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',5,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'5983E71C-90C4-47DA-8161-F6F35FD41CAB',1 UNION ALL 
        SELECT 9295, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',12,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'AC4B911E-1D11-4DF7-9FDC-68B5B76DFB0F',1 UNION ALL 
        SELECT 9300, 'I usually feel confident where money is concerned.',10,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'80987103-BD67-4306-8049-2F3BABD27AF6',1 UNION ALL 
        SELECT 9301, 'I want my investment money to be safe even if it means lower returns.',18,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'49FA544A-35E8-47A0-991F-A3958310305F',1 UNION ALL 
        SELECT 9302, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'1FB396A9-568C-4F1E-BB41-61943BF618A0',1 UNION ALL 
        SELECT 9303, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'F7A2EC05-0793-4340-BF8D-ED16D88C454A',1 UNION ALL 
        SELECT 9304, 'I would prefer small certain gains to large uncertain ones.',16,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'4C426590-1E10-4E87-B337-D5C7EAD591EF',1 UNION ALL 
        SELECT 9305, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'66C97BB6-13A6-4A35-990B-03095710EE6E',1 UNION ALL 
        SELECT 9306, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',11,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'4E9E899A-DCD1-48EC-8B3E-319FB1C4092C',1 UNION ALL 
        SELECT 9307, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',14,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'5DEE1A92-93FA-4C68-83DA-38A1BEE8162B',1 UNION ALL 
        SELECT 9308, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'6722BB5E-8A35-428D-B9F3-934BDE8C4F5A',1 UNION ALL 
        SELECT 9309, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',8,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'85496901-E227-4D38-ADF8-111C68AEBD1B',1 UNION ALL 
        SELECT 9310, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',15,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'30F1A788-A14B-4129-83EB-36E31981685B',1 UNION ALL 
        SELECT 9311, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'26173281-BC32-435F-BA4D-CC58B447FAB8',1 UNION ALL 
        SELECT 9285, 'How would a close friend describe your attitude to taking financial risks?',8,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'84A10B60-A0E2-4776-81B1-7BB1FC39A837',1 UNION ALL 
        SELECT 9286, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',6,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'A061FFDF-6B18-4521-A1A1-5DE040D12B02',1 UNION ALL 
        SELECT 9287, 'I want my investment money to be safe even if it means lower returns.',13,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'E6558C45-58B7-4A5E-AE8C-69C319D3F3D3',1 UNION ALL 
        SELECT 9288, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'1DFD4F84-FB52-4C35-8312-ECCC54351942',1 UNION ALL 
        SELECT 9289, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'14ACB188-A8D5-4FB1-89F2-33602FC605F8',1 UNION ALL 
        SELECT 9290, 'I would prefer small certain gains to large uncertain ones.',11,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'8F52CDB6-8101-4108-AD29-C744328FD189',1 UNION ALL 
        SELECT 9291, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',7,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'4413251C-7DC9-478F-82CA-0419C789BC06',1 UNION ALL 
        SELECT 9292, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',9,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'01F7B4B5-712A-4E2B-81B8-D54091C64AE9',1 UNION ALL 
        SELECT 9293, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',10,1,1,1,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',466,'81511D4E-37DA-4CFF-BFE3-A0ABF9FCC858',1 UNION ALL 
        SELECT 9312, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'797930C2-8EEF-47F2-B113-119643CD49A4',1 UNION ALL 
        SELECT 9313, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'136E7C5C-F177-4093-8D7E-027CB663B785',466,'F8120C0F-2B01-424D-B75B-BE189731FAF4',1 UNION ALL 
        SELECT 9314, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'04C5CD92-B10B-4C3A-9E5A-796FBA11016C',1 UNION ALL 
        SELECT 9315, 'Compared to others, what amount of risk have you taken with your past financial decisions?',4,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'8D3C29D6-AFC6-419D-9CC3-DCD2DBBE75FD',1 UNION ALL 
        SELECT 9316, 'How would a close friend describe your attitude to taking financial risks?',8,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'869E7529-64E7-428F-BA35-B89271628501',1 UNION ALL 
        SELECT 9317, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',6,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'5EB17FB5-2243-4853-90A4-B29EA9E10E12',1 UNION ALL 
        SELECT 9318, 'I want my investment money to be safe even if it means lower returns.',13,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'3250D606-3D92-4076-BD86-4019933EC772',1 UNION ALL 
        SELECT 9319, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'4EE2DDAB-D9FC-4AD1-9C41-C0DD3C74CD97',1 UNION ALL 
        SELECT 9320, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'A36B6AC2-592A-4D83-9001-B1633A656C57',1 UNION ALL 
        SELECT 9321, 'I would prefer small certain gains to large uncertain ones.',11,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'1314C70E-7376-49A4-8895-3D5C1A431127',1 UNION ALL 
        SELECT 9322, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',7,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'6F937DE9-8E93-4AE3-A9C2-61EC198B92FE',1 UNION ALL 
        SELECT 9323, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',9,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'3122ECB4-0577-4F45-B68C-9C32B1D0F3C9',1 UNION ALL 
        SELECT 9324, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',10,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'D715FD3D-3757-46BE-B3E1-F8E6CAEA05D4',1 UNION ALL 
        SELECT 9325, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',5,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'C191F176-735F-48EF-AB37-E2DC488F0FD4',1 UNION ALL 
        SELECT 9326, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',12,1,1,1,'2B128DA8-539A-4681-847B-6F9680F474B6',466,'422C6560-9635-4771-9BC2-F16A96E4E291',1 UNION ALL 
        SELECT 9327, 'Compared to other people, how would you describe your typical attitude when making important financial decisions?',3,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'E96D5D78-7F63-4B2D-A568-5F6BAC9BF0D1',1 UNION ALL 
        SELECT 9328, 'Compared to others, what amount of risk have you taken with your past financial decisions?',5,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'4875F79D-81D4-40A9-86A1-42388D371892',1 UNION ALL 
        SELECT 9329, 'How would a close friend describe your attitude to taking financial risks?',12,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'B1B76646-CC51-4F5F-B5D3-AD8DA2BB916E',1 UNION ALL 
        SELECT 9330, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'2224E25A-63E9-47F2-A284-B876B09F9D6F',1 UNION ALL 
        SELECT 9331, 'I usually feel confident where money is concerned.',10,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'D9536C17-4DAD-495B-A480-F21A2DF44754',1 UNION ALL 
        SELECT 9332, 'I want my investment money to be safe even if it means lower returns.',18,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'B3D3998A-4586-4BCD-BF3F-B96004B43E82',1 UNION ALL 
        SELECT 9333, 'I would enjoy exploring investment opportunities for my money.',1,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'FAC323E0-DD8C-4F9D-91EB-FAD29CFE8C65',1 UNION ALL 
        SELECT 9334, 'I would go for the best possible return even if there were risk involved.',2,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'E4138846-1271-4698-AE3C-666709A8B3ED',1 UNION ALL 
        SELECT 9335, 'I would prefer small certain gains to large uncertain ones.',16,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'65E3ACBF-C169-481A-9002-75913A76896D',1 UNION ALL 
        SELECT 9336, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'1B8D905A-D716-4DD5-A662-39C6CA95B600',1 UNION ALL 
        SELECT 9337, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but an equal element of risk?',11,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'32082765-F137-4347-8AFE-E00E7F5D1EB4',1 UNION ALL 
        SELECT 9338, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',14,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'C8D41672-F372-490C-A6DB-5D4C707F0518',1 UNION ALL 
        SELECT 9339, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'4655E43E-A8EA-47EC-9C74-4192C4420F90',1 UNION ALL 
        SELECT 9340, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',8,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'4C120BA5-744A-48CA-B081-123C5D328316',1 UNION ALL 
        SELECT 9341, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',15,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'62BB1D2A-13D8-4FB1-B449-EB4333B7DFB3',1 UNION ALL 
        SELECT 9342, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'03E9D86A-E2EA-4370-AFC4-DB2DFF31CCD5',1 UNION ALL 
        SELECT 9343, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'279CFAC6-94EC-4750-9DF2-DBC7ED19687B',1 UNION ALL 
        SELECT 9344, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',466,'45D199D2-A632-4F89-B63C-296134E18094',1 UNION ALL 
        SELECT 14993, 'When I consider investments that have an element of risk I feel quite anxious',7,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'CDF9C13B-C594-4B1F-B1CA-A70E010908F2',2 UNION ALL 
        SELECT 14994, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',8,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'7743242F-9D36-45C1-B3FA-A70E01098783',2 UNION ALL 
        SELECT 15000, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',14,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'39D40341-195F-4F0C-B818-A70E010C25E1',2 UNION ALL 
        SELECT 14990, 'If I had money invested in shares I would be nervous about the stock market falling in the short term',4,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'C3E9EE24-18D9-4180-838C-A70E0107779D',2 UNION ALL 
        SELECT 14991, 'What amount of risk do you feel you have taken with your past financial decisions?',5,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'29024B80-AA1F-4329-9E56-A70E010808F2',2 UNION ALL 
        SELECT 15180, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'0C724FDE-F985-447E-BADB-A73000991AAB',2 UNION ALL 
        SELECT 15181, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'BC651AB2-1CEF-497C-83FB-A730009A6AE4',2 UNION ALL 
        SELECT 15184, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall',5,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'C67BE42C-2035-4E65-AA59-A730009C4235',2 UNION ALL 
        SELECT 14989, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'14BC3093-8073-4A83-9391-A70E0105984E',2 UNION ALL 
        SELECT 14992, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'BF3E3E44-0F96-47B5-AAA7-A70E0108A277',2 UNION ALL 
        SELECT 15185, 'When I consider investments that have an element of risk I feel quite anxious',6,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'5EEB1696-86FA-469D-877C-A730009CD8B8',2 UNION ALL 
        SELECT 15186, 'Imagine that six months after making an investment the financial markets start to perform badly. In line with this, your own investment goes down by a significant amount. What would your reaction be?',7,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'BD1F2F08-F7AF-460E-83A0-A730009F8551',2 UNION ALL 
        SELECT 15191, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose?',12,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'E5F95FB7-F73A-4D32-967E-A73000A39E37',2 UNION ALL 
        SELECT 15002, 'I would prefer small certain gains to large uncertain ones',16,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'E860649D-5DAA-44DA-9FB8-A70E010CE0B7',2 UNION ALL 
        SELECT 15189, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',10,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'B7B6AFDD-C804-470C-9606-A73000A152DB',2 UNION ALL 
        SELECT 14988, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'FFDDE587-F4EF-4AEB-BF6B-A70E01050E36',3 UNION ALL 
        SELECT 15183, 'What amount of risk do you feel you have taken with your past financial decisions?',4,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'5EA78118-673E-4241-A606-A730009BD1DE',2 UNION ALL 
        SELECT 15182, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'F0BA48D4-FB08-4A81-AD3F-A730009AD844',2 UNION ALL 
        SELECT 15188, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',9,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'2FF7E5D7-9757-41B7-860B-A73000A0846B',2 UNION ALL 
        SELECT 12277, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'9EE5931C-852D-4720-88F1-D89D6BAC434B',1 UNION ALL 
        SELECT 12278, 'I would go for the best possible return even if there were risk involved',2,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'1E72FEBD-2A82-4783-A291-6217C271BE62',1 UNION ALL 
        SELECT 12279, 'How would you describe your typical attitude when making important financial decisions?',3,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'2F844922-9532-4745-927F-071587004BD5',1 UNION ALL 
        SELECT 12280, 'If I had money invested in shares I would be nervous about the stock market falling in the short term.',4,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'A46EA039-0FE7-43B1-ABC0-1E3B7ECC4A83',1 UNION ALL 
        SELECT 12281, 'What amount of risk do you feel you have taken with your past financial decisions? ',5,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'82359CBE-BB11-4913-B285-6CB4D1EC408F',1 UNION ALL 
        SELECT 12282, 'To reach my financial goal I prefer an investment which is safe and grows slowly but steadily, even if it means lower growth overall.',6,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'D498D5B2-86A5-41E9-8D31-D8923D9373AF',1 UNION ALL 
        SELECT 12283, 'When I consider investments that have an element of risk I feel quite anxious.',7,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'F0D7A1FB-BF5C-48BC-B185-8069EC6253E1',1 UNION ALL 
        SELECT 12284, 'Imagine that six months after making an investment the financial markets start to perform badly.  In line with this, your own investment goes down by a significant amount.  What would your reaction be?',8,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'298EB307-6BFF-4730-9110-B22B1F6708A6',1 UNION ALL 
        SELECT 12285, 'I am looking for high investment growth.  I am willing to accept the possibility of greater losses to achieve this.',9,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'91996381-DA02-434B-AD86-9B40D79DC92D',1 UNION ALL 
        SELECT 12286, 'I usually feel confident where money is concerned.',10,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'030B55DA-2900-4CED-9FA9-73603D8D56B1',1 UNION ALL 
        SELECT 12287, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',11,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'7E348156-727B-4034-B7CB-B5C7AF0FE6EA',1 UNION ALL 
        SELECT 12288, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',12,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'3819226B-75A7-49C3-8BF1-3D90F8FF9507',1 UNION ALL 
        SELECT 12289, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'107F897B-DC8D-449F-ABEB-04F470642D3E',1 UNION ALL 
        SELECT 12290, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel',14,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'2B37971F-6894-4AE0-9236-9C9106772C68',1 UNION ALL 
        SELECT 12291, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose? ',15,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'B5B9A76A-9321-45BE-9AAB-541550C19693',1 UNION ALL 
        SELECT 12292, 'I would prefer small certain gains to large uncertain ones',16,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'919C9AC1-D6E8-48B9-98FE-D75C7BE52F83',1 UNION ALL 
        SELECT 12293, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'1FE96AFA-BCA4-47C4-AD16-791E1C07EEB9',1 UNION ALL 
        SELECT 12294, 'I want my investment money to be safe even if it means lower returns',18,1,1,1,'9E3FBB8E-646D-41BA-A2F3-527525474581',466,'EE1AF29E-CC3B-47B2-9A46-8AA64EB04300',1 UNION ALL 
        SELECT 14987, 'I would enjoy exploring investment opportunities for my money',1,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'33B78390-C0FC-4AD8-ABB6-A70E01047383',2 UNION ALL 
        SELECT 14995, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this',9,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'DC63F051-F9BB-478F-B5B8-A70E0109E467',2 UNION ALL 
        SELECT 14998, 'How do you think that a friend who knows you well would describe your attitude to taking financial risks?',12,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'AA8B049D-932D-432C-A026-A70E010B383C',2 UNION ALL 
        SELECT 15003, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',17,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'3848FB36-09C3-4CD8-9B06-A70E010D47CF',2 UNION ALL 
        SELECT 15004, 'I want my investment money to be safe even if it means lower returns',18,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'164F71CB-BFA0-4417-92FD-A70E010DB6BE',2 UNION ALL 
        SELECT 14997, 'If you had money to invest, how much would you be willing to place in an investment with possible high returns but a similar chance of losing some of your money?',11,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'C13D1A2D-3BE7-44B8-B70F-A70E010AD25E',2 UNION ALL 
        SELECT 15187, 'I am looking for high investment growth. I am willing to accept the possibility of greater losses to achieve this.',8,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'530687F0-1527-4CBF-9E8A-A73000A008DD',2 UNION ALL 
        SELECT 15190, 'If you had picked an investment with potential for large gains but also the risk of large losses how would you feel?',11,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'F9433003-D6A4-4F24-BAD2-A73000A2DD9A',2 UNION ALL 
        SELECT 15193, 'When considering a major financial decision which statement BEST describes the way you think about the possible losses or the possible gains?',14,1,1,1,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',466,'CBB8298C-9AF9-4FDC-BB68-A73000A4785E',2 UNION ALL 
        SELECT 14996, 'I usually feel confident where money is concerned.',10,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'99E76D70-EFBA-4463-82F9-A70E010A5EA0',2 UNION ALL 
        SELECT 15001, 'Imagine that you have some money to invest and a choice of two investment products, which option would you choose? ',15,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'A43356A9-05D3-4527-A8B5-A70E010C93F4',2 UNION ALL 
        SELECT 14999, 'If you had spare funds to invest, would you choose a risky investment for the excitement of seeing how it would perform?',13,1,1,1,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',466,'80CA309F-58D0-4A41-AADF-A70E010BCCFB',2 
 
        SET IDENTITY_INSERT TAtrQuestion OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4B9A9AE1-F846-40AB-8786-4106D705CAD8', 
         'Initial load (239 total rows, file 1 of 1) for table TAtrQuestion',
         466, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 239
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
