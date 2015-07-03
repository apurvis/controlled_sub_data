s = Substance.where(name: 'Phencyclidine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'PCP')

s = Substance.where(name: 'Methylphenobarbital').first
SubstanceAlternateName.create(substance_id: s.id, name: 'Mephobarbital')

s = Substance.where(name: 'Dimethyltryptamine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Diethyltryptamine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Nabilone').first
s.first_scheduled_date = "1987-04-07".to_date
s.save

s = Substance.where(name: 'Peyote')
s.comment = "Meaning all parts of the plant presently classified botanically as Lophophora Willamsli Lemalre, whether growing or not; the seeds thereof; any extract from any part of such plant; and every compound, manufacture. salt. derivative, mixture or preparation of such plant, its seeds or extracts.  Interpretation re-published January 21, 1976"
s.save
