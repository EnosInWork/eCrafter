INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_vendeur','vendeur',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_vendeur','vendeur',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_vendeur', 'vendeur', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('vendeur', 'vendeur', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('vendeur', 0, 'soldato', 'Dealer', 200, 'null', 'null'),
('vendeur', 1, 'capo', 'Braqueur', 400, 'null', 'null'),
('vendeur', 2, 'consigliere', 'Bandit', 600, 'null', 'null'),
('vendeur', 3, 'boss', 'Chef', 1000, 'null', 'null');

INSERT INTO `items` (`name`, `label`) VALUES 
('metaux', 'Métaux'), 
('canon', 'Canon'),
('meche', 'Mèche'),
('levier', 'Levier');