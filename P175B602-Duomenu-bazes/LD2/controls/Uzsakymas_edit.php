<?php

	include 'libraries/Uzsakymas.class.php';
	$uzsakymasObj = new Uzsakymas();
	
	include 'libraries/Preke.class.php';
	$prekeObj = new Preke();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('uzsakymoNumeris', 'transportavimoKaina', 'pristatymoBudas', 'fk_AptarnaujantisAsistentastabelioNr', 'fk_PirkejasuzsakymoNumeris', 'kiekiai');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'uzsakymoNumeris' => 7
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'uzsakymoNumeris' => 'alfanum',
			'uzsakymoData' => 'date',
			'nuolaida' => 'int',
			'nuolaidosKodas' => 'anything',
			'transportavimoKaina' => 'price',
			'prekiuKiekis' => 'positivenumber',
			'pristatymoBudas' => 'positivenumber',
			'fk_Pirkejaskodas' => 'alfanum',
			'fk_AptarnaujantisAsistentastabelioNr' => 'alfanum',
			'kiekiai' => 'positivenumber');
				
		
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			if(isset($data['editing'])) {
				// atnaujiname duomenis
				$uzsakymasObj->updateUzsakymas($data);
				$deleteQueryClause = "";
				if(isset($data['uzsakymoPreke'])) {
					foreach($data['uzsakymoPreke'] as $key=>$val) {
						if($data['neaktyvus'][$key] == 1) {
							$deleteQueryClause .= " AND NOT `id`='" . $data['idk'][$key] . "'";
						}
					}
					$uzsakymasObj->deleteUzsakymoPreke($data['uzsakymoNumeris'], $deleteQueryClause);
					// atnaujiname kategorijas, kurios nėra naudojamos sporto šakose						
					$uzsakymasObj->insertUzsakymoPreke($data);
				}
				else{
					$formErrors = "Visų užsakymo prekių ištrinti negalima, turi likti bent viena, išeikite iš puslapio ir iš naujo spauskite redaguoti.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				}
				$count = $uzsakymasObj->getUzsakymoPrekeCount($data['uzsakymoNumeris']);
				if ($count == 0){
					// sudarome klaidų pranešimą
					$formErrors = "Uzsakymas turi turėti bent vieną užsakymo prekę.";
					
					$uzsakymasObj->insertUzsakymoPreke($data);
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				}
			} else {
				
				$tmp = $uzsakymasObj->getUzsakymas($data['uzsakymoNumeris']);
				$count = $uzsakymasObj->getUzsakymoPrekeCount($data['uzsakymoNumeris']);
				
				if(isset($tmp['uzsakymoNumeris'])){
					if ($count == 0){
						// sudarome klaidų pranešimą
						$formErrors = "Uzsakymas su įvestu numeriu jau egzistuoja ir užsakymas turi turėti bent vieną užsakymo prekę.";
					}
					else{
						$formErrors = "Uzsakymas su įvestu numeriu jau egzistuoja.";
					}
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
				// įrašome naują užsakymą
					$uzsakymasObj->insertUzsakymas($data);
					$uzsakymasObj->insertUzsakymoPreke($data);
					
					$kiekis = $uzsakymasObj->getUzsakymoPrekeCount($data['uzsakymoNumeris']);
					if($kiekis == 0){
						// sudarome klaidų pranešimą
						$formErrors = "Uzsakymas turi turėti bent vieną užsakymo prekę.";
						// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
						$fields = $_POST;
					}
					$uzsakymasObj->deleteUzsakymas($data['uzsakymoNumeris']);
				}
			}
			if($formErrors == null) {
				// nukreipiame vartotoją į užsakymų puslapį
				header("Location: index.php?module={$module}");
				die();
			}
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
			
			if(isset($_POST['kiekiai']) && sizeof($_POST['kiekiai']) > 0) {
				$i = 0;
				foreach($_POST['kiekiai'] as $key => $val) {
					$fields['uzsakymoPrekes'][$i]['kiekis'] = $val;
					$fields['uzsakymoPrekes'][$i]['id'] = $_POST['idk'][$key];
					$fields['uzsakymoPrekes'][$i]['neaktyvus'] = $_POST['neaktyvus'][$key];
					$i++;
				}
			}
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame prekę
			$fields = $uzsakymasObj->getUzsakymas($id);
			$tmp = $uzsakymasObj->getUzsakymoPreke($id);
			if(sizeof($tmp)) {
				foreach($tmp as $key => $val) {
					// jeigu kategorija yra naudojama, jos koreguoti neleidziame ir įvedimo laukelį padarome neaktyvų
					if(sizeof($tmp) == 1) {
						$val['neaktyvus'] = 1;
					}
					$fields['uzsakymoPrekes'][] = $val;
				}
				
			}
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Užsakymai</a></li>
	<li><?php if(!empty($id)) echo "Užsakymo redagavimas"; else echo "Naujas užsakymas"; ?></li>
</ul>
<div class="float-clear"></div>
<div id="formContainer">
	<?php if($formErrors != null) { ?>
		<div class="errorBox">
			Neįvesti arba neteisingai įvesti šie laukai:
			<?php 
				echo $formErrors;
			?>
		</div>
	<?php } ?>
	<form action="" method="post">
		<fieldset>
			<legend>Užsakymo informacija</legend>
			<p>
				<label class="field" for="uzsakymoNumeris">Užsakymo numeris<?php echo in_array('uzsakymoNumeris', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="uzsakymoNumeris" name="uzsakymoNumeris" class="textbox-150" value="<?php echo isset($fields['uzsakymoNumeris']) ? $fields['uzsakymoNumeris'] : ''; ?>" />
						<?php if(key_exists('uzsakymoNumeris', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['uzsakymoNumeris']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['uzsakymoNumeris']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="uzsakymoNumeris" value="<?php echo $fields['uzsakymoNumeris']; ?>" />
					<?php } ?>
			</p>
			<p>
				<label class="field" for="uzsakymoData">Užsakymo data<?php echo in_array('uzsakymoData', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="uzsakymoData" name="uzsakymoData" class="date textbox-70" value="<?php echo isset($fields['uzsakymoData']) ? $fields['uzsakymoData'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="nuolaida">Nuolaida<?php echo in_array('nuolaida', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="nuolaida" name="nuolaida" class="textbox-150" value="<?php echo isset($fields['nuolaida']) ? $fields['nuolaida'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="nuolaidosKodas">Nuolaidos kodas<?php echo in_array('nuolaidosKodas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="nuolaidosKodas" name="nuolaidosKodas" class="textbox-70" value="<?php echo isset($fields['nuolaidosKodas']) ? $fields['nuolaidosKodas'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="transportavimoKaina">Transportavimo kaina<?php echo in_array('transportavimoKaina', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="transportavimoKaina" name="transportavimoKaina" class="textbox-70" value="<?php echo isset($fields['transportavimoKaina']) ? $fields['transportavimoKaina'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="prekiuKiekis">Prekių kiekis<?php echo in_array('prekiuKiekis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="prekiuKiekis" name="prekiuKiekis" class="textbox-70" value="<?php echo isset($fields['prekiuKiekis']) ? $fields['prekiuKiekis'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="pristatymoBudas">Pristatymo būdas<?php echo in_array('pristatymoBudas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="pristatymoBudas" name="pristatymoBudas">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$pristatymoBudasObj = $uzsakymasObj->getPristatymoBudasList();
						foreach($pristatymoBudasObj as $key => $val) {
							$selected = "";
							if(isset($fields['pristatymoBudas']) && $fields['pristatymoBudas'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_AptarnaujantisAsistentastabelioNr">Aptarnaujančio asistento tabelio nr.<?php echo in_array('fk_AptarnaujantisAsistentastabelioNr', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_AptarnaujantisAsistentastabelioNr" name="fk_AptarnaujantisAsistentastabelioNr">
					<option value="-1">Pasirinkite asistentą</option>
					<?php
						// išrenkame visus asistentus
						$asistentai = $uzsakymasObj->getAsistentasList();
						foreach($asistentai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_AptarnaujantisAsistentastabelioNr']) && $fields['fk_AptarnaujantisAsistentastabelioNr'] == $val['tabelioNr']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['tabelioNr']}'>{$val['tabelioNr']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_Pirkejaskodas">Pirkėjo kodas<?php echo in_array('fk_Pirkejaskodas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_Pirkejaskodas" name="fk_Pirkejaskodas">
					<option value="-1">Pasirinkite pirkėją</option>
					<?php
						// išrenkame visus pirkėjus
						$pirkejai = $uzsakymasObj->getPirkejasList();
						foreach($pirkejai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_Pirkejaskodas']) && $fields['fk_Pirkejaskodas'] == $val['kodas']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['kodas']}'>{$val['kodas']}</option>";
						}
					?>
				</select>
			</p>
		</fieldset>
		
		<fieldset>
			<legend>Užsakymo prekės</legend>
			<div class="childRowContainer">
				<div class="labelLeft<?php if(empty($fields['uzsakymoPrekes']) || sizeof($fields['uzsakymoPrekes']) == 0) echo ' hidden'; ?>">Prekė</div>
				<div class="labelLeft<?php if(empty($fields['uzsakymoPrekes']) || sizeof($fields['uzsakymoPrekes']) == 0) echo ' hidden'; ?>">Kiekis</div>
				<div class="float-clear"></div>
				<?php
					if(empty($fields['uzsakymoPrekes']) || sizeof($fields['uzsakymoPrekes']) == 0) {
				?>
					<div class="childRow hidden">
						<input type="hidden" class="isDisabledForEditing" name="idk[]" value="" />
						<input type="hidden" class="isDisabledForEditing" name="neaktyvus[]" value="0" />
						<select class="elementSelector" name="uzsakymoPreke[]" disabled="disabled">
							<?php
								$tmp = $uzsakymasObj->getPrekeList();
								foreach($tmp as $key => $val) {
									$selected = "";
									if(isset($fields['fk_Prekekodas']) && $fields['fk_Prekekodas'] == $val['kodas']) {
										$selected = " selected='selected'";
									}
									echo "<option{$selected} value='{$val['kodas']}'>{$val['kodas']}</option>";
								}
							?>
						</select>
						<input type="text" name="kiekiai[]" class="textbox-30" value="" disabled="disabled" />
						<a href="#" title="" class="removeChild<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo " hidden"; ?>">šalinti</a>
					</div>
					<div class="float-clear"></div>

				<?php
					} else {
						foreach($fields['uzsakymoPrekes'] as $key => $val) {
				?>
						<div class="childRow">
							<input type="hidden" class="isDisabledForEditing" name="idk[]" value="<?php echo $val['id']; ?>" />
							<input type="hidden" class="isDisabledForEditing" name="neaktyvus[]" value="<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo "1"; else echo "0"; ?>" />
							<select class="elementSelector" name="uzsakymoPreke[]">
								<?php
									$tmp = $uzsakymasObj->getPrekeList();
									foreach($tmp as $key1 => $val1) {
										$selected = "";
										if($val['fk_Prekekodas'] == $val1['kodas']) {
											$selected = " selected='selected'";
										}
										echo "<option{$selected} value='{$val1['kodas']}'>{$val1['kodas']}</option>";
									}
								?>
							</select>
							<input type="text" name="kiekiai[]" class="textbox-30" value="<?php echo isset($val['kiekis']) ? $val['kiekis'] : ''; ?>" />
							<a href="#" title="" class="removeChild<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo " hidden"; ?>">šalinti</a>
						</div>
						<div class="float-clear"></div>
				<?php 
						}
					}
				?>
			</div>
			<p id="newItemButtonContainer">
				<a href="#" title="" class="addChild">Pridėti</a>
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
		<?php if(isset($fields['id'])) { ?>
			<input type="hidden" name="id" value="<?php echo $fields['id']; ?>" />
		<?php } ?>
	</form>
</div>