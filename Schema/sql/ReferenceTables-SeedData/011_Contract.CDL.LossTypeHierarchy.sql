INSERT INTO REF.LossTypeHierarchy (lossTypeCode, parentLossTypeCode) VALUES
    ('CovA', 'Building'),
    ('CovB', 'Building'),
    ('CovC', 'Contents'),
    ('CovD', 'BI'),
    ('Building', 'Property'),
    ('Contents', 'Property'),
    ('BI', 'Property'),
    ('Casualty', 'Loss'),
    ('Property', 'Loss')
    ;
