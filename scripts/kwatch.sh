# kubectl wait --for=condition=Established --timeout=-1s crds applications.argoproj.io
trap 'echo "Caught Ctrl+C. Exiting gracefully."; exit 1' SIGINT

readyIcon=$(echo -e "\e[0;32m\u2714\e[0m")
waitingIcon=$(echo -e "\e[1;33m\u23F3\e[0m")


function kwaitCrd {
    local crd=$1

    gum spin --spinner minidot --spinner.foreground=46 --title  " [ ${crd} ] - Creating... " -- kubectl wait --for=create crds $crd --timeout=-1s
    gum spin --spinner dot --spinner.foreground=82 --title " [ ${crd} ] - Progressing..." -- kubectl wait --for=condition=Established crds $crd --timeout=-1s; 

    gum style \
        --margin "0 2" \
        --bold \
        -- \
        "${readyIcon} ${crd} - Established";
    
}



echo -e ":building_construction: &nbsp; Checking CRDs &nbsp; :package:" | gum format -t emoji |  gum style \
        --foreground 214 --border-foreground 214 --border none \
        --align center  --width 25 --margin "0 0" --padding "1 0"  --bold 


crdList="helmcharts.helm.cattle.io resourcegraphdefinitions.kro.run applications.argoproj.io applicationsets.argoproj.io argofiles.kro.run mikrolabs.kro.run ingressrequests.kro.run certmanagerbundles.kro.run certificaterequests.cert-manager.io certificates.cert-manager.io"

for crd in $crdList; do
    kwaitCrd "$crd"
done



# for crd in $(kubectl get crds -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | sort); do
#     if [[ "$crd" != "helmcharts.helm.cattle.io" && "$crd" != "resourcegraphdefinitions.kro.run" && "$crd" != "applications.argoproj.io" && "$crd" != "applicationsets.argoproj.io" && "$crd" != "argofiles.kro.run" && "$crd" != "mikrolabs.kro.run" && "$crd" != "ingressrequests.kro.run" && "$crd" != "certmanagerbundles.kro.run" && "$crd" != "certificaterequests.cert-manager.io" && "$crd" != "certificates.cert-manager.io" ]]; then
#         kwaitCrdShort "$crd"
#     fi
# done