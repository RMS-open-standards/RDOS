INSERT INTO REF.ContractType (contractTypeCode, parentContractTypeCode, contractTypeDesc, isActive) VALUES
('Insurance',null,'Insurance',1),
('Reinsurance',null,'Reinsurance',1),
('Policy','Insurance','Policy',1),
('FAC','Reinsurance','Facultative Cession',1),
('Treaty','Reinsurance','Treaty',1),
('PrimaryPolicy','Policy','Primary Policy',1),
('ExcessPolicy','Policy','Excess Policy',1),
('PerRisk','Treaty','Per Risk Reinsurance',1),
('CatastropheReinsurance','Treaty','Catastrophe Reinsurance',1),
('SurplusShare','PerRisk','Surplus Share Treaty',1),
('QuotaShare','PerRisk','Quota Share Treaty',1),
('WorkingExcess','PerRisk','Working Excess Treaty',1),
('CAT','CatastropheReinsurance','Catastrophe Treaty',1),
('SSCession','PerRisk','Surplus Share Cession',1)
;
