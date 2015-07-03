s = Substance.where(name: 'Phencyclidine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'PCP')

s = Substance.where(name: 'Methylphenobarbital').first
SubstanceAlternateName.create(substance_id: s.id, name: 'Mephobarbital')
