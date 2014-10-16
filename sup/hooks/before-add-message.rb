subj = message.subj.downcase
if subj.start_with? '[mplszczecin]'
      message.add_label :mplszczecin
end
