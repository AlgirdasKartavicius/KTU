<?php

/**
 * Pakuotės dydžių redagavimo klasė
 *
 * @author MK
 */

class PakuotesDydis {

	public function __construct() {
		
	}
	
	/**
	 * Pakuotės dydžio išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getPakuotesDydis($id) {
		$query = "  SELECT *
					FROM `PakuotesDydis`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Pakuotės dydžių sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getPakuotesDydisList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `PakuotesDydis`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Pakuotės dydžių kiekio radimas
	 * @return type
	 */
	public function getPakuotesDydisListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `PakuotesDydis`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Pakuotės dydžio įrašymas
	 * @param type $data
	 */
	public function insertPakuotesDydis($data) {
		$query = "  INSERT INTO `PakuotesDydis`
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
	 * Pakuotės dydžio atnaujinimas
	 * @param type $data
	 */
	public function updatePakuotesDydis($data) {
		$query = "  UPDATE `PakuotesDydis`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Pakuotės dydžio šalinimas
	 * @param type $id
	 */
	public function deletePakuotesDydis($id) {
		$query = "  DELETE FROM `PakuotesDydis`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pakuotės dydžių kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getSiuntaCountOfPakuotesDydis($id) {
		$query = "  SELECT COUNT(`PakuotesDydis`.`id`) AS `kiekis`
					FROM `PakuotesDydis`
						INNER JOIN `Siunta`
							ON `PakuotesDydis`.`id`=`Siunta`.`pakuotesDydis`
					WHERE `PakuotesDydis`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios pakuotės dydžio id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfPakuotesDydis() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `PakuotesDydis`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}