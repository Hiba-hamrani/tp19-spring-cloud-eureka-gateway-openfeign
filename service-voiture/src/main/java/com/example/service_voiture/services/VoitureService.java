package com.example.service_voiture.services;

import com.example.service_voiture.entities.Voiture;
import com.example.service_voiture.repositories.VoitureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VoitureService {

	@Autowired
	VoitureRepository voitureRepository;

	public Voiture enregistrerVoiture(Voiture voiture) {
		return voitureRepository.save(voiture);
	}

}
