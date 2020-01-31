INSERT INTO REF.PayoutFunction (payoutFunctionCode, payoutFunctionDesc) VALUES
    ('LIMIT','Pays share * (min(limit, max(0, loss - attachment)))'),
    ('CONSTANT ','If loss > attachment, pays share * payoutAmount')
;
