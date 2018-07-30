<?php

/**
 * Spalvų redagavimo klasė
 *
 * @author MK
 */

class Spalva {

	public function __construct() {
		
	}
	
	/**
	 * Spalvos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSpalva($id) {
		$query = "  SELECT *
					FROM `Spalva`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Spalvų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSpalvaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `Spalva`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Spalvų kiekio radimas
	 * @return type
	 */
	public function getSpalvaListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `Spalva`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Spalvos įrašymas
	 * @param type $data
	 */
	public function insertSpalva($data) {
		$query = "  INSERT INTO `Spalva`
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
	 * Spalvos atnaujinimas
	 * @param type $data
	 */
	public function updateSpalva($data) {
		$query = "  UPDATE `Spalva`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Spalvos šalinimas
	 * @param type $id
	 */
	public function deleteSpalva($id) {
		$query = "  DELETE FROM `Spalva`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Spalvų kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getPrekeCountOfSpalva($id) {
		$query = "  SELECT COUNT(`Spalva`.`id`) AS `kiekis`
					FROM `Spalva`
						INNER JOIN `Preke`
							ON `Spalva`.`id`=`Preke`.`spalva`
					WHERE `Spalva`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios spalvos id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfSpalva() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `Spalva`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}