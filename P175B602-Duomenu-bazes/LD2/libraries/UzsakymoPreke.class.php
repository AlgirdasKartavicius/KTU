<?php

/**
 * Užsakymo prekių redagavimo klasė
 *
 * @author MK
 */

class UzsakymoPreke {

	public function __construct() {
		
	}
	
	/**
	 * Užsakymo prekės išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getUzsakymoPreke($id) {
		$query = "  SELECT `UzsakymoPreke`.`kiekis`,
						   `UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`,
						   `UzsakymoPreke`.`fk_Prekekodas`,
						   `UzsakymoPreke`.`id`
					FROM `UzsakymoPreke`
					WHERE `UzsakymoPreke`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Užsakymo prekės atnaujinimas
	 * @param type $data
	 */
	public function updateUzsakymoPreke($data) {
		$query = "  UPDATE `UzsakymoPreke`
					SET    `kiekis`='{$data['kiekis']}',
						   `fk_UzsakymasuzsakymoNumeris`='{$data['fk_UzsakymasuzsakymoNumeris']}',
						   `fk_Prekekodas`='{$data['fk_Prekekodas']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}

	/**
	 * Užsakymo prekės įrašymas
	 * @param type $data
	 */
	public function insertUzsakymoPreke($data) {
		$query = "  INSERT INTO `UzsakymoPreke` 
								(
									`kiekis`,
									`fk_UzsakymasuzsakymoNumeris`,
									`fk_Prekekodas`,
									`id`
								) 
								VALUES
								(
									'{$data['kiekis']}',
									'{$data['fk_UzsakymasuzsakymoNumeris']}',
									'{$data['fk_Prekekodas']}',
									'{$data['id']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Užsakymo prekių sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getUzsakymoPrekeList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `UzsakymoPreke`.`id`,
						   `UzsakymoPreke`.`kiekis`,
						   `Preke`.`kodas` AS `preke`,
						   `Uzsakymas`.`uzsakymoNumeris` AS `uzsakymas`
					FROM `UzsakymoPreke`
						LEFT JOIN `Preke`
							ON `UzsakymoPreke`.`fk_Prekekodas`=`Preke`.`kodas`
						LEFT JOIN `Uzsakymas`
							ON `UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`=`Uzsakymas`.`uzsakymoNumeris` " . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Užsakymo prekių kiekio radimas
	 * @return type
	 */
	public function getUzsakymoPrekeListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `UzsakymoPreke`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Užsakymo prekės šalinimas
	 * @param type $id
	 */
	public function deleteUzsakymoPreke($id) {
		$query = "  DELETE FROM `UzsakymoPreke`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Prėkės kodų sąrašo išrinkimas
	 * @return type
	 */
	public function getPrekeList() {
		$query = "  SELECT *
					FROM `Preke`";
		$data = mysql::select($query);
		
		return $data;
	}	
	
	/**
	 * Užsakymų sąrašo išrinkimas
	 * @return type
	 */
	public function getUzsakymasList() {
		$query = "  SELECT *
					FROM `Uzsakymas`";
		$data = mysql::select($query);
		
		return $data;
	}	
	
	/**
	 * Didžiausiausios užsakymo prekės id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfUzsakymoPreke() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `UzsakymoPreke`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
	public function getPrekeCountOfIrankis($id){
		$query = "	SELECT COUNT(1) AS `kiekis`
					FROM `Preke`
					WHERE `Preke`.`fk_SportoSakosIrankioKategorijaid` = '{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
}