<?php

	include 'libraries/Saskaita.class.php';
	$saskaitaObj = new Saskaita();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('nr', 'suma', 'mokejimoBudas', 'fk_Pirkejaskodas', 'fk_AptarnaujantisAsistentastabelioNr');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'nr' => 5
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'nr' => 'alfanum',
			'data' => 'date',
			'suma' => 'price',
			'mokejimoData' => 'date',
			'mokejimoBudas' => 'positivenumber',
			'fk_Pirkejaskodas' => 'alfanum',
			'fk_AptarnaujantisAsistentastabelioNr' => 'alfanum');
				
		
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			
			if(isset($data['editing'])) {
				// atnaujiname duomenis
				$saskaitaObj->updateSaskaita($data);
			} else {
				$tmp = $saskaitaObj->getSaskaita($data['nr']);
				
				if(isset($tmp['nr'])){
					// sudarome klaidų pranešimą
					$formErrors = "Sąskaita su įvestu numeriu jau egzistuoja.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
				// įrašome naują sąskaitą
					$saskaitaObj->insertSaskaita($data);
				}
				
			}
			if($formErrors == null) {
				// nukreipiame vartotoją į sąskaitų puslapį
				header("Location: index.php?module={$module}");
				die();
			}
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame prekę
			$fields = $saskaitaObj->getSaskaita($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Sąskaitos</a></li>
	<li><?php if(!empty($id)) echo "Sąskaitos redagavimas"; else echo "Nauja sąskaita"; ?></li>
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
			<legend>Sąskaitos informacija</legend>
			<p>
				<label class="field" for="nr">Sąskaitos numeris<?php echo in_array('nr', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="nr" name="nr" class="textbox-150" value="<?php echo isset($fields['nr']) ? $fields['nr'] : ''; ?>" />
						<?php if(key_exists('nr', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['nr']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['nr']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="nr" value="<?php echo $fields['nr']; ?>" />
					<?php } ?>
			</p>
			<p>
				<label class="field" for="data">Data<?php echo in_array('data', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="data" name="data" class="date textbox-70" value="<?php echo isset($fields['data']) ? $fields['data'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="suma">Suma<?php echo in_array('suma', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="suma" name="suma" class="textbox-70" value="<?php echo isset($fields['suma']) ? $fields['suma'] : ''; ?>">
				<?php if(key_exists('suma', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['suma']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="mokejimoData">Mokėjimo data<?php echo in_array('mokejimoData', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="mokejimoData" name="mokejimoData" class="date textbox-70" value="<?php echo isset($fields['mokejimoData']) ? $fields['mokejimoData'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="mokejimoBudas">Mokėjimo būdas<?php echo in_array('mokejimoBudas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="mokejimoBudas" name="mokejimoBudas">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$mokejimoBudasObj = $saskaitaObj->getMokejimoBudasList();
						foreach($mokejimoBudasObj as $key => $val) {
							$selected = "";
							if(isset($fields['mokejimoBudas']) && $fields['mokejimoBudas'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
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
						$pirkejai = $saskaitaObj->getPirkejasList();
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
			<p>
				<label class="field" for="fk_AptarnaujantisAsistentastabelioNr">Aptarnaujančio asistento tabelio nr.<?php echo in_array('fk_AptarnaujantisAsistentastabelioNr', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_AptarnaujantisAsistentastabelioNr" name="fk_AptarnaujantisAsistentastabelioNr">
					<option value="-1">Pasirinkite asistentą</option>
					<?php
						// išrenkame visus asistentus
						$asistentai = $saskaitaObj->getAsistentasList();
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