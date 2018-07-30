<?php

/**
 * Pristatymo būdų redagavimo klasė
 *
 * @author MK
 */

class PristatymoBudas {

	public function __construct() {
		
	}
	
	/**
	 * Pristatymo būdo išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getPristatymoBudas($id) {
		$query = "  SELECT *
					FROM `PristatymoBudas`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Pristatymo būdų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getPristatymoBudasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `PristatymoBudas`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Pristatymo būdų kiekio radimas
	 * @return type
	 */
	public function getPristatymoBudasListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `PristatymoBudas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Pristatymo būdo įrašymas
	 * @param type $data
	 */
	public function insertPristatymoBudas($data) {
		$query = "  INSERT INTO `PristatymoBudas`
								(
									`id`,
									`name`
								)
								VALUES
								(
									'{$data['id']}',
									'{$data['name']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Pristatymo būdo atnaujinimas
	 * @param type $data
	 */
	public function updatePristatymoBudas($data) {
		$query = "  UPDATE `PristatymoBudas`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Pristatymo būdo šalinimas
	 * @param type $id
	 */
	public function deletePristatymoBudas($id) {
		$query = "  DELETE FROM `PristatymoBudas`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pristatymo būdų kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getUzsakymasCountOfPristatymoBudas($id) {
		$query = "  SELECT COUNT(`PristatymoBudas`.`id`) AS `kiekis`
					FROM `PristatymoBudas`
						INNER JOIN `Uzsakymas`
							ON `PristatymoBudas`.`id`=`Uzsakymas`.`pristatymoBudas`
					WHERE `PristatymoBudas`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios pristatymo būdo id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfPristatymoBudas() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `PristatymoBudas`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}