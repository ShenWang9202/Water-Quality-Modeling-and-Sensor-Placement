function PipeReactionCoeff = CalculatePipeReactionCoeff(VelocityPipe,LinkDiameterPipe,Kb_all,Kw_all,PipeIndex)

VISCOS = 1.1E-5;
DIFFUS  = 1.3E-5;
% /* Store value of viscosity & diffusivity */
ucf = 1.0;
% If the unit is SI, then ucf = sqr(MperFT), when the flow unit is CFS
% if (par->Unitsflag == SI)
% ucf = SQR(MperFT);

% Relative Viscosity MEANS Ratio of the kinematic viscosity of the fluid to that of water at 20 deg. C (1.0 centistokes or 0.94 sq ft/day) (unitless).
RelativeViscosity = 1.0;
RelativeDiffusivity = 1.0;

Viscosity = VISCOS * RelativeViscosity;
Diffusivity = DIFFUS * RelativeDiffusivity;
% Reynolds_number;  Velocity is in feet/second, LinkDiameterPipe is in feet, Viscosity is feet square/second
RE = VelocityPipe.*LinkDiameterPipe./Viscosity;  %https://en.wikipedia.org/wiki/Reynolds_number
% mass transfer coefficient (length/time)
%Sc = Schmidt number (kinematic viscosity of water divided by the diffusivity of the chemical)
Sc = Viscosity/Diffusivity;
[~,n] = size(RE);
% Kf = [];
% for i = 1:n
%     if(RE(i) < 1.0 )
%         Sh = 2.0;
%     elseif (RE(i) >= 2300.0)
%         Sh = 0.0149 * RE(i)^0.88 * Sc^(0.333);
%     else
%         temp = LinkDiameterPipe(i)/LinkLengthPipe(i)*RE(i)*Sc;
%         Sh = 3.65 + 0.0668*temp/(1 + 0.04*(temp)^(0.667));
%     end
%     Kf = [Kf Sh * Diffusivity / LinkDiameterPipe(i)];
% end


% Bulk reaction
Kb = Kb_all(PipeIndex);
% wall reaction rate constant (length/time)
Kw = Kw_all(PipeIndex);
% Kwall = 4.* Kw .* Kf ./ LinkDiameterPipe ./ (abs(Kw) + Kf)
% K = Kb + Kwall;
K = Kb;
PipeReactionCoeff = K;
PipeReactionCoeff = PipeReactionCoeff/Constants4Concentration.DayInSecond;
%PipeReactionCoeff = PipeReactionCoeff/(24*60);