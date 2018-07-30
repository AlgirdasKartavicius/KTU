<?php

	include 'libraries/TransportoPriemones.class.php';
	$transportoPriemonesObj = new TransportoPriemones();

	include 'libraries/SiuntuPervezimoTarnyba.class.php';
	$siuntuPervezimoTarnybaObj = new SiuntuPervezimoTarnyba();
	
	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus laukus
	$required = array('pavadinimas', 'transportoPriemonesTalpa', 'pristatymoGreitisValandomis', 'transportoPriemoniuKiekis', 'laukimoTarifasUzValanda', 'transportoPriemone');

	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'pavadinimas' => 20
	);
	
	// paspaustas išsaugojimo mygtukas
	if(!empty($_POST['submit'])) {
		// sukuriame validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'pavadinimas' => 'anything',
			'transportoPriemonesTalpa' => 'float',
			'pristatymoGreitisValandomis' => 'float',
			'transportoPriemoniuKiekis' => 'int',
			'laukimoTarifasUzValanda' => 'float',
			'transportoPriemone' => 'positivenumber');
		
		$validator = new validator($validations, $required, $maxLengths);
		
		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$siuntuPervezimoTarnybaObj->updateSiuntuPervezimoTarnyba($data);
			} else {
				// randame didžiausią siuntų pervežimo tarnybos id duomenų bazėje
				$latestId = $siuntuPervezimoTarnybaObj->getMaxIdOfSiuntuPervezimoTarnyba();

				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$siuntuPervezimoTarnybaObj->insertSiuntuPervezimoTarnyba($data);
			}
			
			// nukreipiame į siuntų pervežimo tarnybos puslapį
			header("Location: index.php?module={$module}");
			die();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// gauname įvestus laukus
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			$fields = $siuntuPervezimoTarnybaObj->getSiuntuPervezimoTarnyba($id);
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Siuntų pervežimo tarnybos</a></li>
	<li><?php if(!empty($id)) echo "Tarnybos redagavimas"; else echo "Nauja tarnyba"; ?></li>
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
			<legend>Siuntų pervežimo tarnybos informacija</legend>
			<p>
				<label class="field" for="TransportoPriemones">Transporto priemonė<?php echo in_array('transportoPriemone', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="TransportoPriemones" name="transportoPriemone">
					<option value="-1">Pasirinkite transporto priemonę</option>
					<?php
						// išrenkame visas sporto šakas
						$sportoSakos = $transportoPriemonesObj->getTransportoPriemonesList();
						foreach($sportoSakos as $key => $val) {
							$selected = "";
							if(isset($fields['transportoPriemone']) && $fields['transportoPriemone'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="name">Pavadinimas<?php echo in_array('pavadinimas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="name" name="pavadinimas" class="textbox-150" value="<?php echo isset($fields['pavadinimas']) ? $fields['pavadinimas'] : ''; ?>">
				<?php if(key_exists('pavadinimas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pavadinimas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="transportoPriemonesTalpa">Transporto priemonės talpa<?php echo in_array('transportoPriemonesTalpa', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="transportoPriemonesTalpa" name="transportoPriemonesTalpa" class="textbox-150" value="<?php echo isset($fields['transportoPriemonesTalpa']) ? $fields['transportoPriemonesTalpa'] : ''; ?>">
				<?php if(key_exists('transportoPriemonesTalpa', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['transportoPriemonesTalpa']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="pristatymoGreitisValandomis">Pristatymo greitis valandomis<?php echo in_array('pristatymoGreitisValandomis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pristatymoGreitisValandomis" name="pristatymoGreitisValandomis" class="textbox-150" value="<?php echo isset($fields['pristatymoGreitisValandomis']) ? $fields['pristatymoGreitisValandomis'] : ''; ?>">
				<?php if(key_exists('pristatymoGreitisValandomis', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pristatymoGreitisValandomis']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="transportoPriemoniuKiekis">Transporto priemonių kiekis<?php echo in_array('transportoPriemoniuKiekis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="transportoPriemoniuKiekis" name="transportoPriemoniuKiekis" class="textbox-150" value="<?php echo isset($fields['transportoPriemoniuKiekis']) ? $fields['transportoPriemoniuKiekis'] : ''; ?>">
				<?php if(key_exists('transportoPriemoniuKiekis', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['transportoPriemoniuKiekis']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="laukimoTarifasUzValanda">Laukimo tarifas už valandą<?php echo in_array('laukimoTarifasUzValanda', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="laukimoTarifasUzValanda" name="laukimoTarifasUzValanda" class="textbox-150" value="<?php echo isset($fields['laukimoTarifasUzValanda']) ? $fields['laukimoTarifasUzValanda'] : ''; ?>">
				<?php if(key_exists('laukimoTarifasUzValanda', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['laukimoTarifasUzValanda']} simb.)</span>"; ?>
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