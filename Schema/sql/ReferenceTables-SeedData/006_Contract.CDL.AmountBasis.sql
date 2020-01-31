INSERT INTO REF.AmountBasis (amountBasisCode, amountBasisDesc) VALUES
    ('MONEY','The amount is a quantity of money, in the currency specified by ContractTerm.Currency. ContractLayer.PayoutCurrency or ContractLayer.AttachmentBasis'),
    ('PART_COVERED','The amount is a fraction of the replacement cost of the subject. ( 0..1)'),
    ('PART_AFFECTED','The amount is a fraction of the replacement cost of the subject exposure that took loss. ( 0..1)'),
    ('PART_LOSS','The amount is a fraction of the loss. (0..1)'),
    ('TIME','The amount is the number of days between the loss occurrence and the start of coverage. (Used for TimeElement loss types such as Business Interruption)')
;
