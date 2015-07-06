s = Substance.where(name: 'Phencyclidine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'PCP')

s = Substance.where(name: 'Methylphenobarbital').first
SubstanceAlternateName.create(substance_id: s.id, name: 'Mephobarbital')

s = Substance.where(name: 'Dimethyltryptamine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Diethyltryptamine').first
s.comment = "additional language first seen in 36 FR 7802; April 24, 1971"
s.save
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Nabilone').first
s.first_scheduled_date = "1987-04-07".to_date
s.save

s = Substance.where(name: 'Peyote').first
s.comment = "Meaning all parts of the plant presently classified botanically as Lophophora Willamsli Lemalre, whether growing or not; the seeds thereof; any extract from any part of such plant; and every compound, manufacture. salt. derivative, mixture or preparation of such plant, its seeds or extracts.  Interpretation re-published January 21, 1976"
s.save

s = Substance.where(name: '3,4-methylenedioxy amphetamine')
SubstanceAlternateName.create(substance_id: s.id, name: 'MDA')
