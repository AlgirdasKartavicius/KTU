<?php

/**
 * Mokėjimo būdų redagavimo klasė
 *
 * @author MK
 */

class MokejimoBudas {

	public function __construct() {
		
	}
	
	/**
	 * Mokėjimo būdo išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getMokejimoBudas($id) {
		$query = "  SELECT *
					FROM `MokejimoBudas`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Mokėjimo būdų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getMokejimoBudasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `MokejimoBudas`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Mokėjimo būdų kiekio radimas
	 * @return type
	 */
	public function getMokejimoBudasListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `MokejimoBudas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Mokėjimo būdo įrašymas
	 * @param type $data
	 */
	public function insertMokejimoBudas($data) {
		$query = "  INSERT INTO `MokejimoBudas`
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
	 * Mokėjimo būdo atnaujinimas
	 * @param type $data
	 */
	public function updateMokejimoBudas($data) {
		$query = "  UPDATE `MokejimoBudas`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Mokėjimo būdo šalinimas
	 * @param type $id
	 */
	public function deleteMokejimoBudas($id) {
		$query = "  DELETE FROM `MokejimoBudas`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Mokėjimo būdų kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getSaskaitaCountOfMokejimoBudas($id) {
		$query = "  SELECT COUNT(`MokejimoBudas`.`id`) AS `kiekis`
					FROM `MokejimoBudas`
						INNER JOIN `Saskaita`
							ON `MokejimoBudas`.`id`=`Saskaita`.`mokejimoBudas`
					WHERE `MokejimoBudas`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios mokėjimo būdo id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfMokejimoBudas() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `MokejimoBudas`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}