<?php

/**
 * Sezonų redagavimo klasė
 *
 * @author MK
 */

class Sezonas {

	public function __construct() {
		
	}
	
	/**
	 * Sezono išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSezonas($id) {
		$query = "  SELECT *
					FROM `Sezonas`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Sezonų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSezonasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `Sezonas`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Sezonų kiekio radimas
	 * @return type
	 */
	public function getSezonasListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `Sezonas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Sezono įrašymas
	 * @param type $data
	 */
	public function insertSezonas($data) {
		$query = "  INSERT INTO `Sezonas`
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
	 * Sezono atnaujinimas
	 * @param type $data
	 */
	public function updateSezonas($data) {
		$query = "  UPDATE `Sezonas`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Sezono šalinimas
	 * @param type $id
	 */
	public function deleteSezonas($id) {
		$query = "  DELETE FROM `Sezonas`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Sezonų kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getPrekeCountOfSezonas($id) {
		$query = "  SELECT COUNT(`Sezonas`.`id`) AS `kiekis`
					FROM `Sezonas`
						INNER JOIN `Preke`
							ON `Sezonas`.`id`=`Preke`.`sezonas`
					WHERE `Sezonas`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios sezono id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfSezonas() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `Sezonas`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}